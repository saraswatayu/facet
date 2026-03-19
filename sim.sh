#!/usr/bin/env bash
set -euo pipefail

# Facet — Pre-Launch Simulation Engine
# Usage:
#   ./sim.sh run    --config examples/perch.md [--name perch-study] [--concurrency 5]
#   ./sim.sh plan   --config examples/perch.md [--name perch-study]
#   ./sim.sh generate --study output/perch-study/ --config examples/perch.md
#   ./sim.sh synthesize --study output/perch-study/ --config examples/perch.md
#   ./sim.sh status --study output/perch-study/

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
    for section in "IDENTITY" "DISCOVERY" "VERDICT"; do
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

# --- Phase 1: Plan ---
run_plan() {
    local config="$1"
    local study_dir="$2"

    local segments per_segment study_type
    segments=$(parse_frontmatter "$config" "segments")
    per_segment=$(parse_frontmatter "$config" "personas_per_segment")
    study_type=$(parse_frontmatter "$config" "study_type")

    local study_type_rules="${SCRIPT_DIR}/study-types/${study_type}.md"

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
1. Study config: ${config}
2. Planning template (follow these instructions): ${SCRIPT_DIR}/templates/plan.md
3. Study type simulation rules: ${study_type_rules}

Key parameters:
- Segments to create: ${segments}
- Personas per segment: ${per_segment}
- Total personas: $((segments * per_segment))
- Study type: ${study_type}

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

# --- Phase 2: Generate ---
run_generate() {
    local config="$1"
    local study_dir="$2"
    local concurrency="${3:-5}"

    if [ ! -f "${study_dir}/plan.md" ]; then
        echo "ERROR: No plan found at ${study_dir}/plan.md. Run 'plan' first."
        exit 1
    fi

    local study_type
    study_type=$(parse_frontmatter "$config" "study_type")
    local study_type_rules="${SCRIPT_DIR}/study-types/${study_type}.md"

    # Count total personas from config
    local segments per_segment total
    segments=$(parse_frontmatter "$config" "segments")
    per_segment=$(parse_frontmatter "$config" "personas_per_segment")
    total=$((segments * per_segment))

    mkdir -p "${study_dir}/personas"

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  PHASE 2: GENERATING PERSONAS                 ║"
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

        # Launch in background
        (
            FACET_PHASE="Persona ${i}/${total}" \
            claude --print --output-format stream-json \
                --max-turns 15 \
                --allowedTools "Read,Write" \
                -p "You are generating persona ${i} of ${total} for a behavioral simulation study.

Read these files for context:
1. Study config: ${config}
2. Study plan (segment matrix, persona outlines, name registry): ${study_dir}/plan.md
3. Persona template (follow these instructions): ${SCRIPT_DIR}/templates/persona.md
4. Study type simulation rules: ${study_type_rules}

You are generating persona number ${i} (persona-${padded}).
Find persona #${i} in the plan's persona outlines and generate a full persona for that outline.

Write the complete persona to: ${output_path}" \
                2>&1 | $STREAM_FILTER

            if validate_persona "$output_path" 2>/dev/null; then
                echo "  done: persona-${padded}.md"
            else
                echo "  WARN: persona-${padded}.md (validation issues)"
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

# --- Phase 3: Weave ---
run_weave() {
    local config="$1"
    local study_dir="$2"

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  PHASE 3: WEAVING CROSS-REFERENCES            ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    FACET_PHASE="Phase 3: Weaving cross-persona connections" \
    claude --print --verbose --output-format stream-json \
        --max-turns 75 \
        --allowedTools "Read,Write,Edit,Glob,Grep" \
        -p "You are running Phase 3 (Weaving) of a Facet behavioral simulation study.

Read these files for context:
1. Study plan (includes cross-reference plan): ${study_dir}/plan.md
2. Weaving instructions: ${SCRIPT_DIR}/templates/weave.md

Then read ALL persona files in: ${study_dir}/personas/

Follow the weaving instructions to add cross-persona connections, referral chains,
and social links between personas. Use the Edit tool to update existing persona files." \
        2>&1 | $STREAM_FILTER

    update_status "$study_dir" "weave" "complete"
}

# --- Phase 4: Synthesize ---
run_synthesize() {
    local config="$1"
    local study_dir="$2"

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  PHASE 4: SYNTHESIZING RESULTS                ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    FACET_PHASE="Phase 4: Synthesizing results" \
    claude --print --verbose --output-format stream-json \
        --max-turns 50 \
        --allowedTools "Read,Write,Glob,Grep" \
        -p "You are running Phase 4 (Synthesis) of a Facet behavioral simulation study.

Read these files for context:
1. Study config: ${config}
2. Study plan: ${study_dir}/plan.md
3. Synthesis instructions: ${SCRIPT_DIR}/templates/synthesis.md

Then read ALL persona files in: ${study_dir}/personas/

Follow the synthesis instructions to produce a comprehensive analysis.
Write the synthesis to: ${study_dir}/synthesis.md" \
        2>&1 | $STREAM_FILTER

    if [ ! -s "${study_dir}/synthesis.md" ]; then
        echo "ERROR: Synthesis was not generated."
        exit 1
    fi

    update_status "$study_dir" "synthesize" "complete"
}

# --- Phase 5: Artifacts ---
run_artifacts() {
    local config="$1"
    local study_dir="$2"

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  PHASE 5: GENERATING ARTIFACTS                ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    FACET_PHASE="Phase 5: Generating actionable artifacts" \
    claude --print --verbose --output-format stream-json \
        --max-turns 20 \
        --allowedTools "Read,Write,Glob,Grep" \
        -p "You are running Phase 5 (Artifacts) of a Facet behavioral simulation study.

Read these files for context:
1. Study config: ${config}
2. Synthesis: ${study_dir}/synthesis.md
3. Artifacts instructions: ${SCRIPT_DIR}/templates/artifacts.md

Follow the artifacts instructions to generate actionable deliverables.
Write the artifacts to: ${study_dir}/artifacts.md" \
        2>&1 | $STREAM_FILTER

    update_status "$study_dir" "artifacts" "complete"
}

# --- Phase 6: Adversarial ---
run_adversarial() {
    local study_dir="$1"

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  PHASE 6: ADVERSARIAL REVIEW                  ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    FACET_PHASE="Phase 6: Devil's advocate counterargument" \
    claude --print --verbose --output-format stream-json \
        --max-turns 20 \
        --allowedTools "Read,Write,Glob,Grep" \
        -p "You are running Phase 6 (Adversarial Review) of a Facet behavioral simulation study.

Read these files for context:
1. Synthesis: ${study_dir}/synthesis.md
2. Adversarial instructions: ${SCRIPT_DIR}/templates/adversarial.md

IMPORTANT: Do NOT read the individual persona files. Your counterargument should
challenge the synthesis on its own terms, without being anchored by the persona details.

Follow the adversarial instructions to build the strongest possible case AGAINST
the synthesis recommendation.
Write the counterargument to: ${study_dir}/counterargument.md" \
        2>&1 | $STREAM_FILTER

    update_status "$study_dir" "adversarial" "complete"
}

# --- Show status ---
show_status() {
    local study_dir="$1"
    local status_file="${study_dir}/.status"

    if [ ! -f "$status_file" ]; then
        echo "No status file found at ${status_file}"
        exit 1
    fi

    echo ""
    echo "Study: $(basename "$study_dir")"
    echo "---"

    local persona_count
    persona_count=$(find "${study_dir}/personas" -name "persona-*.md" -size +0c 2>/dev/null | wc -l | tr -d ' ')
    echo "Personas generated: ${persona_count}"

    echo ""
    echo "Phase history:"
    while IFS= read -r line; do
        local phase status ts
        phase=$(echo "$line" | python3 -c "import sys,json;print(json.load(sys.stdin)['phase'])" 2>/dev/null || echo "?")
        status=$(echo "$line" | python3 -c "import sys,json;print(json.load(sys.stdin)['status'])" 2>/dev/null || echo "?")
        ts=$(echo "$line" | python3 -c "import sys,json;print(json.load(sys.stdin)['timestamp'])" 2>/dev/null || echo "?")
        echo "  ${phase}: ${status} (${ts})"
    done < "$status_file"

    echo ""
    echo "Output files:"
    for f in plan.md synthesis.md artifacts.md counterargument.md; do
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
        fi
        study_dir="${SCRIPT_DIR}/output/${study_name}"
    fi

    case "$cmd" in
        run)
            [ -z "$config" ] && { echo "Usage: ./sim.sh run --config <file>"; exit 1; }
            mkdir -p "${study_dir}/personas"
            echo ""
            echo "FACET SIMULATION ENGINE"
            echo "Config: $(basename "$config")"
            echo "Output: ${study_dir}"
            echo ""
            run_plan "$config" "$study_dir"
            run_generate "$config" "$study_dir" "$concurrency"
            run_weave "$config" "$study_dir"
            run_synthesize "$config" "$study_dir"
            run_artifacts "$config" "$study_dir"
            run_adversarial "$study_dir"
            echo ""
            echo "STUDY COMPLETE"
            echo "Output: ${study_dir}/"
            ;;
        plan)
            [ -z "$config" ] && { echo "Usage: ./sim.sh plan --config <file>"; exit 1; }
            mkdir -p "${study_dir}/personas"
            run_plan "$config" "$study_dir"
            ;;
        generate)
            [ -z "$study_dir" ] && { echo "Usage: ./sim.sh generate --study <dir> --config <file>"; exit 1; }
            [ -z "$config" ] && { echo "Usage: ./sim.sh generate --study <dir> --config <file>"; exit 1; }
            run_generate "$config" "$study_dir" "$concurrency"
            ;;
        synthesize)
            [ -z "$study_dir" ] && { echo "Usage: ./sim.sh synthesize --study <dir> --config <file>"; exit 1; }
            [ -z "$config" ] && { echo "Usage: ./sim.sh synthesize --study <dir> --config <file>"; exit 1; }
            run_weave "$config" "$study_dir"
            run_synthesize "$config" "$study_dir"
            run_artifacts "$config" "$study_dir"
            run_adversarial "$study_dir"
            ;;
        status)
            [ -z "$study_dir" ] && { echo "Usage: ./sim.sh status --study <dir>"; exit 1; }
            show_status "$study_dir"
            ;;
        help|--help|-h)
            echo "Facet — Pre-Launch Simulation Engine"
            echo ""
            echo "Usage:"
            echo "  ./sim.sh run       --config <file> [--name <name>] [--concurrency N]"
            echo "  ./sim.sh plan      --config <file> [--name <name>]"
            echo "  ./sim.sh generate  --study <dir> --config <file> [--concurrency N]"
            echo "  ./sim.sh synthesize --study <dir> --config <file>"
            echo "  ./sim.sh status    --study <dir>"
            echo ""
            echo "Options:"
            echo "  --config      Path to study config file (markdown + YAML frontmatter)"
            echo "  --name        Study name (default: config filename without .md)"
            echo "  --study       Path to study output directory"
            echo "  --concurrency Number of parallel persona generations (default: 5)"
            ;;
        *)
            echo "Unknown command: $cmd"
            echo "Run './sim.sh help' for usage."
            exit 1
            ;;
    esac
}

main "$@"
