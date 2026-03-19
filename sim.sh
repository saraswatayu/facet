#!/usr/bin/env bash
set -euo pipefail

# Facet v2 — Pre-Launch Simulation Engine
# Usage:
#   ./sim.sh init     --config examples/perch-product.md [--name perch] [--concurrency 5]
#   ./sim.sh exercise --study output/perch/ --config examples/perch-pricing.md [--concurrency 5]
#   ./sim.sh status   --study output/perch/

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STREAM_FILTER="python3 -u ${SCRIPT_DIR}/stream_filter.py"

# --- Parse YAML frontmatter from config ---
parse_frontmatter() {
    local config="$1"
    local key="$2"
    sed -n '/^---$/,/^---$/p' "$config" | grep "^${key}:" | head -1 | sed "s/^${key}: *//" | tr -d '"'
}

# --- Validate persona file ---
validate_persona() {
    local file="$1"
    if [ ! -s "$file" ]; then
        echo "FAIL: Empty or missing: $file"
        return 1
    fi
    local errors=0
    for section in "IDENTITY" "DISCOVERY"; do
        if ! grep -qi "$section" "$file" 2>/dev/null; then
            echo "WARN: Missing section '$section' in $(basename "$file")"
            ((errors++)) || true
        fi
    done
    return $errors
}

# --- Status tracking ---
update_status() {
    local study_dir="$1" phase="$2" status="$3" count="${4:-}" total="${5:-}"
    local ts
    ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    if [ -n "$count" ]; then
        echo "{\"phase\":\"${phase}\",\"status\":\"${status}\",\"count\":${count},\"total\":${total},\"timestamp\":\"${ts}\"}" >> "${study_dir}/.status"
    else
        echo "{\"phase\":\"${phase}\",\"status\":\"${status}\",\"timestamp\":\"${ts}\"}" >> "${study_dir}/.status"
    fi
}

# --- Phase: Plan ---
run_plan() {
    local config="$1"
    local study_dir="$2"

    local segments per_segment
    segments=$(parse_frontmatter "$config" "segments")
    per_segment=$(parse_frontmatter "$config" "personas_per_segment")

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  PHASE 1: PLANNING                            ║"
    echo "║  Segments: ${segments}, Per segment: ${per_segment}              ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    FACET_PHASE="Phase 1: Planning (${segments} segments x ${per_segment} personas)" \
    claude --print --verbose --output-format stream-json \
        --max-turns 20 \
        --allowedTools "Read,Write,Glob,Grep" \
        -p "You are running Phase 1 (Planning) of a Facet behavioral simulation study.

Read these files for context:
1. Product config: ${config}
2. Planning template (follow these instructions): ${SCRIPT_DIR}/templates/plan.md

Key parameters:
- Segments to create: ${segments}
- Personas per segment: ${per_segment}
- Total personas: $((segments * per_segment))

Follow the instructions in the planning template exactly.
Write the complete plan to: ${study_dir}/plan.md" \
        2>&1 | $STREAM_FILTER

    if [ ! -s "${study_dir}/plan.md" ]; then
        echo "ERROR: Plan was not generated."
        exit 1
    fi

    echo ""
    echo "Plan written to ${study_dir}/plan.md"
    update_status "$study_dir" "plan" "complete"
}

# --- Phase: Generate Persona Backgrounds ---
run_generate() {
    local config="$1"
    local study_dir="$2"
    local concurrency="${3:-5}"

    if [ ! -f "${study_dir}/plan.md" ]; then
        echo "ERROR: No plan found at ${study_dir}/plan.md. Run 'init' first."
        exit 1
    fi

    # Count total personas from config
    local segments per_segment total
    segments=$(parse_frontmatter "$config" "segments")
    per_segment=$(parse_frontmatter "$config" "personas_per_segment")
    total=$((segments * per_segment))

    mkdir -p "${study_dir}/personas"
    mkdir -p "${study_dir}/logs"

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  PHASE 2: GENERATING PERSONA BACKGROUNDS      ║"
    echo "║  Total: ${total}, Concurrency: ${concurrency}                    ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    local running=0

    for i in $(seq 1 "$total"); do
        local padded
        padded=$(printf '%03d' "$i")
        local output_path="${study_dir}/personas/persona-${padded}.md"

        # Skip if already generated
        if [ -s "$output_path" ]; then
            echo "  skip: persona-${padded}.md (already exists)"
            continue
        fi

        local log_file="${study_dir}/logs/persona-${padded}.log"

        # Launch in background
        (
            FACET_PHASE="Persona ${i}/${total}" \
            claude --print --verbose --output-format stream-json \
                --max-turns 15 \
                --model sonnet \
                --allowedTools "Read,Write" \
                -p "You are generating persona ${i} of ${total} for a behavioral simulation study.

Read these files for context:
1. Product config: ${config}
2. Study plan (segment matrix, persona outlines, name registry, cross-references): ${study_dir}/plan.md
3. Persona template (follow these instructions): ${SCRIPT_DIR}/templates/persona.md

You are generating persona number ${i} (persona-${padded}).
Find persona #${i} in the plan's persona outlines and generate a full persona BACKGROUND for that outline.

IMPORTANT: Generate ONLY the background (identity, psychology, domain profile, discovery, cross-references).
Do NOT include option simulations, verdicts, or copy reactions — those are generated separately.

Write the complete persona background to: ${output_path}" \
                2>&1 | tee "$log_file" | $STREAM_FILTER

            if validate_persona "$output_path" 2>/dev/null; then
                echo "  done: persona-${padded}.md"
            else
                echo "  WARN: persona-${padded}.md (validation issues, see ${log_file})"
            fi
        ) &

        ((running++)) || true

        # Throttle concurrency
        if [ "$running" -ge "$concurrency" ]; then
            wait -n 2>/dev/null || true
            ((running--)) || true
        fi
    done

    wait

    local completed
    completed=$(find "${study_dir}/personas" -name "persona-*.md" -size +0c 2>/dev/null | wc -l | tr -d ' ')
    local failed=$((total - completed))

    echo ""
    echo "Generation complete: ${completed}/${total} personas (${failed} failed)"

    if [ "$failed" -gt 0 ] && [ "$((failed * 100 / total))" -gt 20 ]; then
        echo "WARNING: >20% failure rate. Consider re-running."
    fi

    update_status "$study_dir" "generate" "complete" "$completed" "$total"
}

# --- Phase: Simulate (per-persona, parallel) ---
run_simulate() {
    local study_dir="$1"
    local exercise_config="$2"
    local exercise_dir="$3"
    local concurrency="${4:-5}"

    local exercise_name study_type
    exercise_name=$(parse_frontmatter "$exercise_config" "exercise_name")
    study_type=$(parse_frontmatter "$exercise_config" "study_type")
    local study_type_rules="${SCRIPT_DIR}/study-types/${study_type}.md"

    mkdir -p "${exercise_dir}/simulations"
    mkdir -p "${exercise_dir}/logs"

    # Count personas
    local total
    total=$(find "${study_dir}/personas" -name "persona-*.md" -size +0c 2>/dev/null | wc -l | tr -d ' ')

    if [ "$total" -eq 0 ]; then
        echo "ERROR: No personas found in ${study_dir}/personas/. Run 'init' first."
        exit 1
    fi

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  SIMULATING: ${exercise_name}"
    echo "║  Personas: ${total}, Concurrency: ${concurrency}                 ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    local running=0

    for persona_file in "${study_dir}/personas"/persona-*.md; do
        local basename
        basename=$(basename "$persona_file" .md)
        local padded="${basename#persona-}"
        local output_path="${exercise_dir}/simulations/${basename}.md"

        # Skip if already generated
        if [ -s "$output_path" ]; then
            echo "  skip: ${basename}.md (already exists)"
            continue
        fi

        local log_file="${exercise_dir}/logs/${basename}.log"

        # Launch in background
        (
            FACET_PHASE="Simulation: ${basename}" \
            claude --print --verbose --output-format stream-json \
                --max-turns 15 \
                --model sonnet \
                --allowedTools "Read,Write" \
                -p "You are simulating persona ${basename} through an exercise for a behavioral simulation study.

Read these files for context:
1. Persona background: ${persona_file}
2. Exercise config (options to test): ${exercise_config}
3. Simulation template (follow these instructions): ${SCRIPT_DIR}/templates/simulation.md
4. Study type simulation rules: ${study_type_rules}

Generate this persona's reactions to the options defined in the exercise config.
Stay completely in character — use the persona's voice, vocabulary, and decision-making patterns from their background.

Write the simulation to: ${output_path}" \
                2>&1 | tee "$log_file" | $STREAM_FILTER

            if [ -s "$output_path" ]; then
                echo "  done: ${basename}.md"
            else
                echo "  WARN: ${basename}.md (empty or missing, see ${log_file})"
            fi
        ) &

        ((running++)) || true

        # Throttle concurrency
        if [ "$running" -ge "$concurrency" ]; then
            wait -n 2>/dev/null || true
            ((running--)) || true
        fi
    done

    wait

    local completed
    completed=$(find "${exercise_dir}/simulations" -name "persona-*.md" -size +0c 2>/dev/null | wc -l | tr -d ' ')
    local failed=$((total - completed))

    echo ""
    echo "Simulation complete: ${completed}/${total} personas (${failed} failed)"

    if [ "$failed" -gt 0 ] && [ "$((failed * 100 / total))" -gt 20 ]; then
        echo "WARNING: >20% failure rate. Consider re-running simulations."
    fi

    update_status "$exercise_dir" "simulate" "complete" "$completed" "$total"
}

# --- Phase: Analyze (single call — synthesis + artifacts + counterargument) ---
run_analyze() {
    local study_dir="$1"
    local exercise_config="$2"
    local exercise_dir="$3"

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  ANALYZING RESULTS                             ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    FACET_PHASE="Analysis: synthesis + artifacts + counterargument" \
    claude --print --verbose --output-format stream-json \
        --max-turns 50 \
        --allowedTools "Read,Write,Glob,Grep" \
        -p "You are running the Analysis phase of a Facet behavioral simulation exercise.

Read these files for context:
1. Exercise config: ${exercise_config}
2. Analysis template (follow these instructions): ${SCRIPT_DIR}/templates/analysis.md

Then read ALL persona background files in: ${study_dir}/personas/
Then read ALL simulation files in: ${exercise_dir}/simulations/

Follow the analysis template to produce a comprehensive analysis.
Write the synthesis to: ${exercise_dir}/synthesis.md
Write the artifacts to: ${exercise_dir}/artifacts.md" \
        2>&1 | $STREAM_FILTER

    if [ ! -s "${exercise_dir}/synthesis.md" ]; then
        echo "ERROR: Synthesis was not generated."
        exit 1
    fi

    update_status "$exercise_dir" "analyze" "complete"
}

# --- Show status ---
show_status() {
    local study_dir="$1"
    local status_file="${study_dir}/.status"

    echo ""
    echo "Study: $(basename "$study_dir")"
    echo "---"

    # Persona count
    local persona_count=0
    if [ -d "${study_dir}/personas" ]; then
        persona_count=$(find "${study_dir}/personas" -name "persona-*.md" -size +0c 2>/dev/null | wc -l | tr -d ' ')
    fi
    echo "Personas generated: ${persona_count}"

    # List exercises
    if [ -d "${study_dir}/exercises" ]; then
        echo ""
        echo "Exercises:"
        for exercise in "${study_dir}/exercises"/*/; do
            if [ -d "$exercise" ]; then
                local ename
                ename=$(basename "$exercise")
                local sim_count=0
                if [ -d "${exercise}/simulations" ]; then
                    sim_count=$(find "${exercise}/simulations" -name "persona-*.md" -size +0c 2>/dev/null | wc -l | tr -d ' ')
                fi
                local has_synthesis="no"
                [ -f "${exercise}/synthesis.md" ] && has_synthesis="yes"
                echo "  ${ename}: ${sim_count} simulations, synthesis: ${has_synthesis}"
            fi
        done
    else
        echo "Exercises: none"
    fi

    # Phase history
    if [ -f "$status_file" ]; then
        echo ""
        echo "Phase history:"
        while IFS= read -r line; do
            local phase status ts
            phase=$(echo "$line" | python3 -c "import sys,json;print(json.load(sys.stdin)['phase'])" 2>/dev/null || echo "?")
            status=$(echo "$line" | python3 -c "import sys,json;print(json.load(sys.stdin)['status'])" 2>/dev/null || echo "?")
            ts=$(echo "$line" | python3 -c "import sys,json;print(json.load(sys.stdin)['timestamp'])" 2>/dev/null || echo "?")
            echo "  ${phase}: ${status} (${ts})"
        done < "$status_file"
    fi

    # Also show exercise-level status
    if [ -d "${study_dir}/exercises" ]; then
        for exercise in "${study_dir}/exercises"/*/; do
            local estatus="${exercise}.status"
            if [ -f "$estatus" ]; then
                echo ""
                echo "  Exercise: $(basename "$exercise")"
                while IFS= read -r line; do
                    local phase status ts
                    phase=$(echo "$line" | python3 -c "import sys,json;print(json.load(sys.stdin)['phase'])" 2>/dev/null || echo "?")
                    status=$(echo "$line" | python3 -c "import sys,json;print(json.load(sys.stdin)['status'])" 2>/dev/null || echo "?")
                    ts=$(echo "$line" | python3 -c "import sys,json;print(json.load(sys.stdin)['timestamp'])" 2>/dev/null || echo "?")
                    echo "    ${phase}: ${status} (${ts})"
                done < "$estatus"
            fi
        done
    fi

    echo ""
    echo "Output files:"
    for f in plan.md; do
        if [ -f "${study_dir}/$f" ]; then
            local lines
            lines=$(wc -l < "${study_dir}/$f" | tr -d ' ')
            echo "  + $f (${lines} lines)"
        else
            echo "  - $f"
        fi
    done
}

# --- Main ---
main() {
    local cmd="${1:-help}"
    shift || true

    local config="" study_dir="" study_name="" concurrency="5"

    while [ $# -gt 0 ]; do
        case "$1" in
            --config) config="$2"; shift 2 ;;
            --study) study_dir="$2"; shift 2 ;;
            --name) study_name="$2"; shift 2 ;;
            --concurrency) concurrency="$2"; shift 2 ;;
            *) echo "Unknown argument: $1"; exit 1 ;;
        esac
    done

    # Resolve config to absolute path
    if [ -n "$config" ] && [[ "$config" != /* ]]; then
        config="${SCRIPT_DIR}/${config}"
    fi

    # Derive study_dir from config if not provided
    if [ -z "$study_dir" ] && [ -n "$config" ]; then
        if [ -z "$study_name" ]; then
            study_name=$(basename "$config" .md)
            # Strip common suffixes for cleaner directory names
            study_name="${study_name%-product}"
        fi
        study_dir="${SCRIPT_DIR}/output/${study_name}"
    fi

    # Resolve study_dir to absolute path
    if [ -n "$study_dir" ] && [[ "$study_dir" != /* ]]; then
        study_dir="${SCRIPT_DIR}/${study_dir}"
    fi

    case "$cmd" in
        init)
            [ -z "$config" ] && { echo "Usage: ./sim.sh init --config <product-config> [--name <name>] [--concurrency N]"; exit 1; }
            mkdir -p "${study_dir}/personas"
            echo ""
            echo "FACET SIMULATION ENGINE v2"
            echo "Config: $(basename "$config")"
            echo "Output: ${study_dir}"
            echo ""
            run_plan "$config" "$study_dir"
            run_generate "$config" "$study_dir" "$concurrency"
            echo ""
            echo "INIT COMPLETE — personas ready for exercises"
            echo "Output: ${study_dir}/"
            echo ""
            echo "Next: ./sim.sh exercise --study ${study_dir} --config <exercise-config>"
            ;;
        exercise)
            [ -z "$study_dir" ] && { echo "Usage: ./sim.sh exercise --study <dir> --config <exercise-config> [--concurrency N]"; exit 1; }
            [ -z "$config" ] && { echo "Usage: ./sim.sh exercise --study <dir> --config <exercise-config> [--concurrency N]"; exit 1; }

            if [ ! -d "${study_dir}/personas" ]; then
                echo "ERROR: No personas directory at ${study_dir}/personas/. Run 'init' first."
                exit 1
            fi

            local exercise_name
            exercise_name=$(parse_frontmatter "$config" "exercise_name")
            if [ -z "$exercise_name" ]; then
                # Fallback: derive from config filename
                exercise_name=$(basename "$config" .md)
            fi

            local exercise_dir="${study_dir}/exercises/${exercise_name}"
            mkdir -p "${exercise_dir}/simulations"

            # Copy exercise config into the exercise directory for reference
            cp "$config" "${exercise_dir}/exercise.md"

            echo ""
            echo "FACET SIMULATION ENGINE v2"
            echo "Study: $(basename "$study_dir")"
            echo "Exercise: ${exercise_name}"
            echo "Config: $(basename "$config")"
            echo ""

            run_simulate "$study_dir" "$config" "$exercise_dir" "$concurrency"
            run_analyze "$study_dir" "$config" "$exercise_dir"

            echo ""
            echo "EXERCISE COMPLETE"
            echo "Results: ${exercise_dir}/"
            echo "  synthesis.md — analysis + recommendation + counterargument"
            echo "  artifacts.md — actionable deliverables"
            echo "  simulations/ — per-persona simulation details"
            ;;
        status)
            [ -z "$study_dir" ] && { echo "Usage: ./sim.sh status --study <dir>"; exit 1; }
            show_status "$study_dir"
            ;;
        help|--help|-h)
            echo "Facet v2 — Pre-Launch Simulation Engine"
            echo ""
            echo "Usage:"
            echo "  ./sim.sh init      --config <product-config> [--name <name>] [--concurrency N]"
            echo "  ./sim.sh exercise  --study <dir> --config <exercise-config> [--concurrency N]"
            echo "  ./sim.sh status    --study <dir>"
            echo ""
            echo "Commands:"
            echo "  init      Plan + generate persona backgrounds (parallel)"
            echo "  exercise  Simulate personas through options (parallel) + analyze"
            echo "  status    Show study progress and exercise results"
            echo ""
            echo "Options:"
            echo "  --config      Path to config file (product config for init, exercise config for exercise)"
            echo "  --name        Study name (default: config filename without .md)"
            echo "  --study       Path to study output directory"
            echo "  --concurrency Number of parallel generations/simulations (default: 5)"
            echo ""
            echo "Workflow:"
            echo "  1. Create a product config (see examples/perch-product.md)"
            echo "  2. ./sim.sh init --config examples/perch-product.md --name perch"
            echo "  3. Create exercise configs (see examples/perch-pricing.md)"
            echo "  4. ./sim.sh exercise --study output/perch/ --config examples/perch-pricing.md"
            echo "  5. Run more exercises against the same personas:"
            echo "     ./sim.sh exercise --study output/perch/ --config examples/perch-copy.md"
            ;;
        *)
            echo "Unknown command: $cmd"
            echo "Run './sim.sh help' for usage."
            exit 1
            ;;
    esac
}

main "$@"
