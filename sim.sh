#!/usr/bin/env bash
set -euo pipefail

# Facet v2 — Pre-Launch Simulation Engine
# Usage:
#   ./sim.sh init     --config examples/perch-product.md [--name perch] [--concurrency 5] [--calibration data.md]
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
    local calibration="${3:-}"

    local segments per_segment
    segments=$(parse_frontmatter "$config" "segments")
    per_segment=$(parse_frontmatter "$config" "personas_per_segment")

    local calibration_instruction=""
    if [ -n "$calibration" ]; then
        if [ -d "$calibration" ]; then
            calibration_instruction="
5. Calibration data directory: ${calibration}

IMPORTANT: A calibration data directory has been provided with real-world research data.
Use Glob to discover all files in this directory (and subdirectories).
If a manifest.md file exists at the root, read it FIRST — it describes each file's purpose and relevance.
Then read the files most relevant to planning (survey data, interview themes, market research).
You do not need to read every file — prioritize files that inform segment design and persona attributes.
Ground persona attributes, behavioral patterns, and segment design in patterns from this data, not just LLM training priors.
In the plan output, add a 'Calibration Sources' section listing which files you read and what you extracted from each."
        else
            calibration_instruction="
5. Calibration data (ground personas in this real-world data): ${calibration}

IMPORTANT: Calibration data has been provided. Use it to ground persona attributes,
behavioral patterns, and segment design in real-world observations. Personas should
reflect patterns found in this data, not just LLM training priors."
        fi
    fi

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  PHASE 1: PLANNING                            ║"
    echo "║  Segments: ${segments}, Per segment: ${per_segment}              ║"
    if [ -n "$calibration" ]; then
        if [ -d "$calibration" ]; then
    echo "║  Calibration: $(basename "$calibration")/ (directory)            ║"
        else
    echo "║  Calibration: $(basename "$calibration")                        ║"
        fi
    fi
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
${calibration_instruction}
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

# --- Extract one-line summary from a persona file ---
extract_persona_summary() {
    local file="$1"
    local padded
    padded=$(basename "$file" .md | sed 's/persona-//')
    # Get the first heading (usually the persona's name)
    local name
    name=$(grep -m1 "^#" "$file" 2>/dev/null | sed 's/^#* *//' || echo "Unknown")
    # Get first 3 non-empty lines of the IDENTITY section
    local identity
    identity=$(sed -n '/IDENTITY/,/^###/{/IDENTITY/d;/^###/d;/^$/d;p;}' "$file" 2>/dev/null | head -3 | tr '\n' ' ' | sed 's/  */ /g' | cut -c1-200)
    echo "- Persona ${padded}: ${name} — ${identity}"
}

# --- Phase: Generate Persona Backgrounds (wave-based) ---
run_generate() {
    local config="$1"
    local study_dir="$2"
    local concurrency="${3:-5}"
    local calibration="${4:-}"
    local wave_size=5

    if [ ! -f "${study_dir}/plan.md" ]; then
        echo "ERROR: No plan found at ${study_dir}/plan.md. Run 'init' first."
        exit 1
    fi

    # Count total personas from config
    local segments per_segment total
    segments=$(parse_frontmatter "$config" "segments")
    per_segment=$(parse_frontmatter "$config" "personas_per_segment")
    total=$((segments * per_segment))

    local wave_count=$(( (total + wave_size - 1) / wave_size ))

    mkdir -p "${study_dir}/personas"
    mkdir -p "${study_dir}/logs"

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  PHASE 2: GENERATING PERSONA BACKGROUNDS      ║"
    echo "║  Total: ${total}, Waves: ${wave_count} x ${wave_size}, Concurrency: ${concurrency}     ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    local generated_summaries=""
    local wave=1

    for wave_start in $(seq 1 "$wave_size" "$total"); do
        local wave_end=$((wave_start + wave_size - 1))
        [ "$wave_end" -gt "$total" ] && wave_end="$total"

        echo "  Wave ${wave}/${wave_count}: personas ${wave_start}-${wave_end}"

        # Build diversity context for this wave
        local diversity_context=""
        if [ -n "$generated_summaries" ]; then
            diversity_context="

ALREADY GENERATED PERSONAS (from previous waves — your persona must be DISTINCT from these):
${generated_summaries}

Your persona must sound, think, and decide differently from ALL of the above.
Do not repeat their financial situations, personality patterns, discovery channels, or emotional responses.
If you notice patterns above (e.g., all positive, all analytical, all urban), deliberately break them."
        fi

        local running=0

        for i in $(seq "$wave_start" "$wave_end"); do
            local padded
            padded=$(printf '%03d' "$i")
            local output_path="${study_dir}/personas/persona-${padded}.md"

            # Skip if already generated
            if [ -s "$output_path" ]; then
                echo "    skip: persona-${padded}.md (already exists)"
                continue
            fi

            local log_file="${study_dir}/logs/persona-${padded}.log"

            # Build calibration context for persona generation
            local persona_calibration=""
            local persona_tools="Read,Write"
            if [ -n "$calibration" ]; then
                if [ -d "$calibration" ]; then
                    persona_calibration="
4. Calibration data directory: ${calibration}
   Use Glob to discover files, then read any that are relevant to THIS persona's segment.
   Ground specific details (salary ranges, behavior patterns, pain points, quotes) in this real data.
   The plan's 'Calibration Sources' section lists what data is available."
                    persona_tools="Read,Write,Glob,Grep"
                else
                    persona_calibration="
4. Calibration data: ${calibration}
   Read this file and ground specific persona details in its real-world data."
                fi
            fi

            # Launch in background
            (
                FACET_PHASE="Persona ${i}/${total} (wave ${wave})" \
                claude --print --verbose --output-format stream-json \
                    --max-turns 15 \
                    --model sonnet \
                    --allowedTools "${persona_tools}" \
                    -p "You are generating persona ${i} of ${total} for a behavioral simulation study.

Read these files for context:
1. Product config: ${config}
2. Study plan (segment matrix, persona outlines, name registry, cross-references): ${study_dir}/plan.md
3. Persona template (follow these instructions): ${SCRIPT_DIR}/templates/persona.md
${persona_calibration}
You are generating persona number ${i} (persona-${padded}).
Find persona #${i} in the plan's persona outlines and generate a full persona BACKGROUND for that outline.

IMPORTANT: Generate ONLY the background (identity, psychology, domain profile, discovery, cross-references).
Do NOT include option simulations, verdicts, or copy reactions — those are generated separately.
${diversity_context}
Write the complete persona background to: ${output_path}" \
                    2>&1 | tee "$log_file" | $STREAM_FILTER

                if validate_persona "$output_path" 2>/dev/null; then
                    echo "    done: persona-${padded}.md"
                else
                    echo "    WARN: persona-${padded}.md (validation issues, see ${log_file})"
                fi
            ) &

            ((running++)) || true

            # Throttle concurrency within wave
            if [ "$running" -ge "$concurrency" ]; then
                wait -n 2>/dev/null || true
                ((running--)) || true
            fi
        done

        # Wait for entire wave to complete before starting next
        wait

        # Build summaries from this wave for the next wave's diversity context
        for i in $(seq "$wave_start" "$wave_end"); do
            local padded
            padded=$(printf '%03d' "$i")
            local pfile="${study_dir}/personas/persona-${padded}.md"
            if [ -s "$pfile" ]; then
                generated_summaries="${generated_summaries}
$(extract_persona_summary "$pfile")"
            fi
        done

        ((wave++))
    done

    local completed
    completed=$(find "${study_dir}/personas" -name "persona-*.md" -size +0c 2>/dev/null | wc -l | tr -d ' ')
    local failed=$((total - completed))

    echo ""
    echo "Generation complete: ${completed}/${total} personas (${failed} failed)"

    if [ "$failed" -gt 0 ] && [ "$((failed * 100 / total))" -gt 20 ]; then
        echo "WARNING: >20% failure rate. Consider re-running."
    fi

    # Post-generate validation summary
    echo ""
    echo "Persona Validation Summary:"
    local dealbreaker_count=0
    local behecon_count=0
    for f in "${study_dir}/personas"/persona-*.md; do
        [ -f "$f" ] || continue
        if grep -qi "deal-breaker\|deal_breaker\|dealbreaker" "$f" 2>/dev/null; then
            ((dealbreaker_count++)) || true
        fi
        if grep -qi "BEHAVIORAL ECONOMICS PROFILE\|reference point\|loss aversion\|mental account" "$f" 2>/dev/null; then
            ((behecon_count++)) || true
        fi
    done
    echo "  Personas with deal-breakers: ${dealbreaker_count}/${completed}"
    echo "  Personas with behavioral economics profile: ${behecon_count}/${completed}"
    if [ "$completed" -gt 0 ] && [ "$dealbreaker_count" -lt "$((completed / 4))" ]; then
        echo "  WARNING: <25% of personas mention deal-breakers. Diversity may be insufficient."
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

    if [ ! -s "${exercise_dir}/artifacts.md" ]; then
        echo "WARNING: Artifacts file was not generated separately. Check synthesis.md for embedded artifacts."
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

    local config="" study_dir="" study_name="" concurrency="5" calibration=""

    while [ $# -gt 0 ]; do
        case "$1" in
            --config) config="$2"; shift 2 ;;
            --study) study_dir="$2"; shift 2 ;;
            --name) study_name="$2"; shift 2 ;;
            --concurrency) concurrency="$2"; shift 2 ;;
            --calibration) calibration="$2"; shift 2 ;;
            *) echo "Unknown argument: $1"; exit 1 ;;
        esac
    done

    # Validate calibration path if provided (file or directory)
    if [ -n "$calibration" ]; then
        if [[ "$calibration" != /* ]]; then
            calibration="${SCRIPT_DIR}/${calibration}"
        fi
        if [ -d "$calibration" ]; then
            # Directory — check it's not empty
            local file_count
            file_count=$(find "$calibration" -type f \( -name "*.md" -o -name "*.csv" -o -name "*.txt" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | wc -l | tr -d ' ')
            if [ "$file_count" -eq 0 ]; then
                echo "ERROR: Calibration directory has no readable files (.md/.csv/.txt/.json/.yaml): $calibration"
                exit 1
            fi
            echo "Calibration: directory with ${file_count} files"
        elif [ -f "$calibration" ]; then
            if [ ! -s "$calibration" ]; then
                echo "ERROR: Calibration file is empty: $calibration"
                exit 1
            fi
        else
            echo "ERROR: Calibration path not found: $calibration"
            exit 1
        fi
    fi

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
            [ -z "$config" ] && { echo "Usage: ./sim.sh init --config <product-config> [--name <name>] [--concurrency N] [--calibration <file>]"; exit 1; }
            mkdir -p "${study_dir}/personas"

            # Version-lock init-phase templates
            mkdir -p "${study_dir}/.templates"
            cp "${SCRIPT_DIR}/templates/plan.md" "${study_dir}/.templates/"
            cp "${SCRIPT_DIR}/templates/persona.md" "${study_dir}/.templates/"
            echo "Templates version-locked to ${study_dir}/.templates/"

            echo ""
            echo "FACET SIMULATION ENGINE v2"
            echo "Config: $(basename "$config")"
            echo "Output: ${study_dir}"
            if [ -n "$calibration" ]; then
                if [ -d "$calibration" ]; then
                    local cal_count
                    cal_count=$(find "$calibration" -type f \( -name "*.md" -o -name "*.csv" -o -name "*.txt" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | wc -l | tr -d ' ')
                    echo "Calibration: $(basename "$calibration")/ (${cal_count} files)"
                else
                    echo "Calibration: $(basename "$calibration")"
                fi
            fi
            echo ""
            run_plan "$config" "$study_dir" "$calibration"
            run_generate "$config" "$study_dir" "$concurrency" "$calibration"
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

            # Version-lock exercise-phase templates + study-type rules
            local study_type
            study_type=$(parse_frontmatter "$config" "study_type")
            mkdir -p "${exercise_dir}/.templates"
            cp "${SCRIPT_DIR}/templates/simulation.md" "${exercise_dir}/.templates/"
            cp "${SCRIPT_DIR}/templates/analysis.md" "${exercise_dir}/.templates/"
            if [ -n "$study_type" ] && [ -f "${SCRIPT_DIR}/study-types/${study_type}.md" ]; then
                cp "${SCRIPT_DIR}/study-types/${study_type}.md" "${exercise_dir}/.templates/"
            fi
            echo "Templates version-locked to ${exercise_dir}/.templates/"

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
            echo "  ./sim.sh init      --config <product-config> [--name <name>] [--concurrency N] [--calibration <file>]"
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
            echo "  --calibration Path to calibration data file OR directory (real research data to ground personas)"
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
