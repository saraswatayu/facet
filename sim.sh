#!/usr/bin/env bash
set -euo pipefail

# Facet v2 — Pre-Launch Simulation Engine
# Usage:
#   ./sim.sh init   --config examples/superhuman-product.md [--name superhuman] [--concurrency 5] [--calibration data.md] [--output-dir /path/to/output]
#   ./sim.sh study  --panel output/superhuman/ --config examples/superhuman-pricing.md [--concurrency 5]
#   ./sim.sh status --panel output/superhuman/
#
# --output-dir: override base output directory (default: ./output/). Used by /facet skill
#               to write study output to the user's project instead of the Facet install dir.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STREAM_FILTER="python3 -u ${SCRIPT_DIR}/stream_filter.py"

# --- Count non-empty files matching a pattern in a directory ---
count_files() {
    local dir="$1" pattern="${2:-*.md}"
    find "$dir" -name "$pattern" -size +0c 2>/dev/null | wc -l | tr -d ' '
}

# --- Parse YAML frontmatter from config ---
parse_frontmatter() {
    local config="$1"
    local key="$2"
    python3 "${SCRIPT_DIR}/parse_config.py" "$config" "$key"
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
    local panel_dir="$1" phase="$2" status="$3" count="${4:-}" total="${5:-}"
    local ts
    ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    if [ -n "$count" ]; then
        echo "{\"phase\":\"${phase}\",\"status\":\"${status}\",\"count\":${count},\"total\":${total},\"timestamp\":\"${ts}\"}" >> "${panel_dir}/.status"
    else
        echo "{\"phase\":\"${phase}\",\"status\":\"${status}\",\"timestamp\":\"${ts}\"}" >> "${panel_dir}/.status"
    fi
}

# --- Time estimation ---
estimate_time() {
    local personas="$1" studies="${2:-1}" concurrency="${3:-5}" extra_search_dir="${4:-}"

    # Try to get historical averages from past .status files
    local avg_gen_per_persona=90  # seconds, baseline
    local avg_sim_per_persona=60
    local avg_analysis=120
    local avg_cross_synth=180

    # Search for historical data in output/ (and --output-dir if provided)
    local history_file
    history_file=$(mktemp "${TMPDIR:-/tmp}/facet-history-XXXXXXXX")
    FACET_SCRIPT_DIR="$SCRIPT_DIR" FACET_EXTRA_DIR="$extra_search_dir" python3 -c "
import json, os, sys, glob
from datetime import datetime

durations = {'generate': [], 'simulate': [], 'analyze': [], 'cross-synthesize': []}

search_paths = [os.environ.get('FACET_SCRIPT_DIR', '') + '/output/**/.status']
extra = os.environ.get('FACET_EXTRA_DIR', '')
if extra:
    search_paths.append(extra + '/**/.status')

for pattern in search_paths:
    for status_file in glob.glob(pattern, recursive=True):
        phases = {}
        try:
            with open(status_file) as f:
                for line in f:
                    line = line.strip()
                    if not line: continue
                    obj = json.loads(line)
                    phase = obj.get('phase', '')
                    status = obj.get('status', '')
                    ts = obj.get('timestamp', '')
                    count = obj.get('count', 0)
                    if ts and phase:
                        key = (phase, status)
                        phases[key] = {'ts': ts, 'count': count}
        except (json.JSONDecodeError, IOError):
            continue

        for phase_name in durations:
            started = phases.get((phase_name, 'started'))
            completed = phases.get((phase_name, 'complete'))
            if started and completed:
                try:
                    t1 = datetime.fromisoformat(started['ts'].replace('Z', '+00:00'))
                    t2 = datetime.fromisoformat(completed['ts'].replace('Z', '+00:00'))
                    dur = (t2 - t1).total_seconds()
                    count = completed.get('count', 1)
                    if dur > 0 and count > 0 and phase_name in ('generate', 'simulate'):
                        durations[phase_name].append(dur / count)
                    elif dur > 0:
                        durations[phase_name].append(dur)
                except (ValueError, TypeError):
                    pass

for phase_name, vals in durations.items():
    if vals:
        avg = sum(vals) / len(vals)
        print(f'{phase_name}={avg:.0f}')
" > "$history_file" 2>/dev/null

    # Override baselines with historical data if available
    while IFS='=' read -r phase_name avg_val; do
        case "$phase_name" in
            generate) avg_gen_per_persona="$avg_val" ;;
            simulate) avg_sim_per_persona="$avg_val" ;;
            analyze) avg_analysis="$avg_val" ;;
            cross-synthesize) avg_cross_synth="$avg_val" ;;
        esac
    done < "$history_file"
    rm -f "$history_file"

    # Calculate estimates
    local waves=$(( (personas + 4) / 5 ))  # wave size = 5
    local gen_time=$(( waves * avg_gen_per_persona ))  # wave-serial, not fully parallel
    local sim_time_per_ex=$(( (personas + concurrency - 1) / concurrency * avg_sim_per_persona ))
    local analysis_time_per_ex="$avg_analysis"
    local total_study_time=$(( studies * (sim_time_per_ex + analysis_time_per_ex) ))
    local total=$(( gen_time + total_study_time + avg_cross_synth ))

    # Format as minutes
    local minutes=$(( (total + 59) / 60 ))
    echo "Estimated time: ~${minutes} min (${personas} personas, ${studies} studies, concurrency ${concurrency})"
}

# --- Template version-locking ---
ensure_version_locked_template() {
    local source="$1"
    local destination="$2"

    if [ ! -f "$destination" ]; then
        cp "$source" "$destination"
    fi
}

version_lock_study_templates() {
    local panel_dir="$1"

    mkdir -p "${panel_dir}/.templates"
    ensure_version_locked_template "${SCRIPT_DIR}/templates/plan.md" "${panel_dir}/.templates/plan.md"
    ensure_version_locked_template "${SCRIPT_DIR}/templates/persona.md" "${panel_dir}/.templates/persona.md"
    ensure_version_locked_template "${SCRIPT_DIR}/templates/cross-synthesis.md" "${panel_dir}/.templates/cross-synthesis.md"
}

version_lock_study_phase_templates() {
    local study_dir="$1"
    local study_type="${2:-}"

    mkdir -p "${study_dir}/.templates"
    ensure_version_locked_template "${SCRIPT_DIR}/templates/simulation.md" "${study_dir}/.templates/simulation.md"
    ensure_version_locked_template "${SCRIPT_DIR}/templates/analysis.md" "${study_dir}/.templates/analysis.md"

    # Validate study_type contains no path separators (prevent path traversal)
    if [ -n "$study_type" ] && [[ "$study_type" != */* ]] && [[ "$study_type" != *..* ]] && [ -f "${SCRIPT_DIR}/study-types/${study_type}.md" ]; then
        ensure_version_locked_template "${SCRIPT_DIR}/study-types/${study_type}.md" "${study_dir}/.templates/${study_type}.md"
    fi
}

# --- Clean run directories for fresh stability runs ---
prepare_run_outputs() {
    local simulations_dir="$1"
    local logs_dir="$2"

    mkdir -p "$simulations_dir"
    mkdir -p "$logs_dir"
    find "$simulations_dir" -maxdepth 1 -type f -name 'persona-*.md' -delete
    find "$logs_dir" -maxdepth 1 -type f -name 'persona-*.log' -delete
}

# --- Phase: Plan ---
run_plan() {
    local config="$1"
    local panel_dir="$2"
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
    update_status "$panel_dir" "plan" "started"

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
2. Planning template (follow these instructions): ${panel_dir}/.templates/plan.md

Key parameters:
- Segments to create: ${segments}
- Personas per segment: ${per_segment}
- Total personas: $((segments * per_segment))
${calibration_instruction}
Follow the instructions in the planning template exactly.
Write the complete plan to: ${panel_dir}/plan.md" \
        2>&1 | $STREAM_FILTER

    if [ ! -s "${panel_dir}/plan.md" ]; then
        echo "ERROR: Plan was not generated."
        return 1
    fi

    echo ""
    echo "Plan written to ${panel_dir}/plan.md"
    update_status "$panel_dir" "plan" "complete"
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
    local panel_dir="$2"
    local concurrency="${3:-5}"
    local calibration="${4:-}"
    local wave_size=5

    if [ ! -f "${panel_dir}/plan.md" ]; then
        echo "ERROR: No plan found at ${panel_dir}/plan.md. Run 'init' first."
        return 1
    fi

    # Count total personas from config
    local segments per_segment total
    segments=$(parse_frontmatter "$config" "segments")
    per_segment=$(parse_frontmatter "$config" "personas_per_segment")
    total=$((segments * per_segment))

    local wave_count=$(( (total + wave_size - 1) / wave_size ))

    mkdir -p "${panel_dir}/personas"
    mkdir -p "${panel_dir}/logs"

    update_status "$panel_dir" "generate" "started" "0" "$total"

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
        local pids=()
        local wave_failures=0

        for i in $(seq "$wave_start" "$wave_end"); do
            local padded
            padded=$(printf '%03d' "$i")
            local output_path="${panel_dir}/personas/persona-${padded}.md"

            # Skip if already generated
            if [ -s "$output_path" ]; then
                echo "    skip: persona-${padded}.md (already exists)"
                continue
            fi

            local log_file="${panel_dir}/logs/persona-${padded}.log"

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
2. Study plan (segment matrix, persona outlines, name registry, cross-references): ${panel_dir}/plan.md
3. Persona template (follow these instructions): ${panel_dir}/.templates/persona.md
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

            pids+=($!)
            ((running++)) || true

            # Throttle concurrency within wave
            if [ "$running" -ge "$concurrency" ]; then
                if ! wait -n 2>/dev/null; then
                    ((wave_failures++)) || true
                fi
                ((running--)) || true
            fi
        done

        # Wait for entire wave to complete and track failures
        for pid in "${pids[@]}"; do
            if ! wait "$pid" 2>/dev/null; then
                ((wave_failures++)) || true
            fi
        done
        if [ "$wave_failures" -gt 0 ]; then
            echo "  WARNING: ${wave_failures} persona(s) failed in wave ${wave}"
        fi

        # Build summaries from this wave for the next wave's diversity context
        for i in $(seq "$wave_start" "$wave_end"); do
            local padded
            padded=$(printf '%03d' "$i")
            local pfile="${panel_dir}/personas/persona-${padded}.md"
            if [ -s "$pfile" ]; then
                generated_summaries="${generated_summaries}
$(extract_persona_summary "$pfile")"
            fi
        done

        ((wave++)) || true
    done

    local completed
    completed=$(count_files "${panel_dir}/personas" "persona-*.md")
    local failed=$((total - completed))

    echo ""
    echo "Generation complete: ${completed}/${total} personas (${failed} failed)"

    if [ "$failed" -gt 0 ] && [ "$((failed * 100 / total))" -ge 20 ]; then
        echo "ERROR: >=20% failure rate (${failed}/${total}). Re-run with: ./sim.sh init --config <config> --name $(basename "$panel_dir")"
        return 1
    fi

    # Post-generate validation summary
    echo ""
    echo "Persona Validation Summary:"
    local dealbreaker_count=0
    local behecon_count=0
    for f in "${panel_dir}/personas"/persona-*.md; do
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

    update_status "$panel_dir" "generate" "complete" "$completed" "$total"
}

# --- Phase: Simulate (per-persona, parallel) ---
run_simulate() {
    local panel_dir="$1"
    local study_config="$2"
    local study_dir="$3"
    local concurrency="${4:-5}"
    local simulations_dir="${5:-${study_dir}/simulations}"
    local logs_dir="${6:-${study_dir}/logs}"

    local study_name study_type
    study_name=$(parse_frontmatter "$study_config" "study_name")
    study_type=$(parse_frontmatter "$study_config" "study_type")

    mkdir -p "$simulations_dir"
    mkdir -p "$logs_dir"

    # Count personas
    local total
    total=$(count_files "${panel_dir}/personas" "persona-*.md")

    if [ "$total" -eq 0 ]; then
        echo "ERROR: No personas found in ${panel_dir}/personas/. Run 'init' first."
        return 1
    fi

    update_status "$study_dir" "simulate" "started" "0" "$total"

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  SIMULATING: ${study_name}"
    echo "║  Personas: ${total}, Concurrency: ${concurrency}                 ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    local running=0
    local pids=()
    local sim_failures=0

    for persona_file in "${panel_dir}/personas"/persona-*.md; do
        local base_name
        base_name=$(basename "$persona_file" .md)
        local padded="${base_name#persona-}"
        local output_path="${simulations_dir}/${base_name}.md"
        local summary_path="${simulations_dir}/${base_name}-summary.md"

        # Skip if both simulation and summary already exist
        if [ -s "$output_path" ] && [ -s "$summary_path" ]; then
            echo "  skip: ${base_name}.md (simulation + summary exist)"
            continue
        fi

        local log_file="${logs_dir}/${base_name}.log"

        # Launch in background
        (
            FACET_PHASE="Simulation: ${base_name}" \
            claude --print --verbose --output-format stream-json \
                --max-turns 15 \
                --model sonnet \
                --allowedTools "Read,Write" \
                -p "You are simulating persona ${base_name} through a study for a behavioral simulation.

Read these files for context:
1. Persona background: ${persona_file}
2. Study config (options to test): ${study_config}
3. Simulation template (follow these instructions): ${study_dir}/.templates/simulation.md
4. Study type simulation rules: ${study_dir}/.templates/${study_type}.md

Generate this persona's reactions to the options defined in the study config.
Stay completely in character — use the persona's voice, vocabulary, and decision-making patterns from their background.

Write the full simulation to: ${output_path}
Also write the structured summary (see the STRUCTURED SUMMARY section in the simulation template) to: ${summary_path}" \
                2>&1 | tee "$log_file" | $STREAM_FILTER

            if [ -s "$output_path" ]; then
                echo "  done: ${base_name}.md"
            else
                echo "  WARN: ${base_name}.md (empty or missing, see ${log_file})"
            fi
        ) &

        pids+=($!)
        ((running++)) || true

        # Throttle concurrency
        if [ "$running" -ge "$concurrency" ]; then
            if ! wait -n 2>/dev/null; then
                ((sim_failures++)) || true
            fi
            ((running--)) || true
        fi
    done

    # Wait for all remaining simulations and track failures
    for pid in "${pids[@]}"; do
        if ! wait "$pid" 2>/dev/null; then
            ((sim_failures++)) || true
        fi
    done
    if [ "$sim_failures" -gt 0 ]; then
        echo "  WARNING: ${sim_failures} simulation(s) failed"
    fi

    local completed
    completed=$(count_files "$simulations_dir" "persona-*.md")
    # Exclude summary files from simulation count
    local summary_count
    summary_count=$(count_files "$simulations_dir" "persona-*-summary.md")
    completed=$((completed - summary_count))
    local failed=$((total - completed))

    echo ""
    echo "Simulation complete: ${completed}/${total} personas (${failed} failed)"
    echo "Summaries written: ${summary_count}/${total}"

    if [ "$failed" -gt 0 ] && [ "$((failed * 100 / total))" -ge 20 ]; then
        echo "ERROR: >=20% simulation failure rate (${failed}/${total}). Re-run the study."
        return 1
    fi

    update_status "$study_dir" "simulate" "complete" "$completed" "$total"
}

# --- Phase: Analyze (single call — synthesis + artifacts + counterargument) ---
run_analyze() {
    local panel_dir="$1"
    local study_config="$2"
    local study_dir="$3"

    update_status "$study_dir" "analyze" "started"

    # Determine whether to use simulation summaries (context engineering)
    # Use summaries when >12 personas AND summary files exist
    local persona_count
    persona_count=$(count_files "${panel_dir}/personas" "persona-*.md")
    local summary_count
    summary_count=$(count_files "${study_dir}/simulations" "persona-*-summary.md")

    local simulation_instruction
    if [ "$persona_count" -gt 12 ] && [ "$summary_count" -eq "$persona_count" ] && [ "$summary_count" -gt 0 ]; then
        simulation_instruction="Then read ALL simulation SUMMARY files in: ${study_dir}/simulations/ (files matching persona-*-summary.md)
These are structured extractions containing verdicts, key quotes, quantitative data, and behavioral economics analysis.
If you need full simulation detail for a specific persona (e.g., for the Key Personas section or counterargument), read their full simulation file (persona-NNN.md without the -summary suffix)."
        echo "  Using simulation summaries (${summary_count} available, ${persona_count} personas)"
    else
        simulation_instruction="Then read ALL simulation files in: ${study_dir}/simulations/"
        if [ "$persona_count" -le 12 ]; then
            echo "  Reading full simulations (${persona_count} personas, under threshold)"
        elif [ "$summary_count" -gt 0 ]; then
            echo "  Reading full simulations (${summary_count}/${persona_count} summaries available; falling back to complete source files)"
        else
            echo "  Reading full simulations (no summaries available)"
        fi
    fi

    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  ANALYZING RESULTS                             ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    FACET_PHASE="Analysis: synthesis + artifacts + counterargument" \
    claude --print --verbose --output-format stream-json \
        --max-turns 50 \
        --allowedTools "Read,Write,Glob,Grep" \
        -p "You are running the Analysis phase of a Facet behavioral simulation study.

Read these files for context:
1. Study config: ${study_config}
2. Analysis template (follow these instructions): ${study_dir}/.templates/analysis.md

Then read ALL persona background files in: ${panel_dir}/personas/
${simulation_instruction}

Follow the analysis template to produce a comprehensive analysis.
Write the synthesis to: ${study_dir}/synthesis.md
Write the artifacts to: ${study_dir}/artifacts.md" \
        2>&1 | $STREAM_FILTER

    if [ ! -s "${study_dir}/synthesis.md" ]; then
        echo "ERROR: Synthesis was not generated."
        return 1
    fi

    if [ ! -s "${study_dir}/artifacts.md" ]; then
        echo "WARNING: Artifacts file was not generated separately. Check synthesis.md for embedded artifacts."
    fi

    update_status "$study_dir" "analyze" "complete"

    # Run spot-check verification if synthesis was generated and summaries were used
    if [ "$persona_count" -gt 12 ] && [ "$summary_count" -eq "$persona_count" ] && [ "$summary_count" -gt 0 ] && [ -s "${study_dir}/synthesis.md" ]; then
        run_spot_check "$panel_dir" "$study_dir" "$persona_count"
    fi
}

# --- Phase: Spot-Check Verification ---
run_spot_check() {
    local panel_dir="$1"
    local study_dir="$2"
    local persona_count="$3"
    local check_count=5
    [ "$persona_count" -lt 10 ] && check_count=3

    echo ""
    echo "  Running spot-check verification (${check_count} personas)..."

    # Pick random persona IDs using study directory name as seed for determinism
    local seed
    seed=$(echo "$(basename "$panel_dir")$(basename "$study_dir")" | cksum | cut -d' ' -f1)
    local selected
    selected=$(python3 -c "
import random
random.seed(${seed})
ids = random.sample(range(1, ${persona_count} + 1), min(${check_count}, ${persona_count}))
for i in ids:
    print(f'{i:03d}')
")

    # Build file lists for the spot-check prompt
    local check_files=""
    for padded in $selected; do
        local persona_file="${panel_dir}/personas/persona-${padded}.md"
        local sim_file="${study_dir}/simulations/persona-${padded}.md"
        local summary_file="${study_dir}/simulations/persona-${padded}-summary.md"
        if [ -f "$persona_file" ] && [ -f "$sim_file" ]; then
            check_files="${check_files}
- Persona background: ${persona_file}
- Full simulation: ${sim_file}"
            [ -f "$summary_file" ] && check_files="${check_files}
- Simulation summary: ${summary_file}"
        fi
    done

    if [ -z "$check_files" ]; then
        echo "  WARN: No persona files found for spot-check. Skipping."
        return 0
    fi

    FACET_PHASE="Spot-check verification" \
    claude --print --verbose --output-format stream-json \
        --max-turns 15 \
        --allowedTools "Read,Write,Grep" \
        -p "You are verifying the accuracy of a synthesis document by spot-checking specific personas.

Read the synthesis: ${study_dir}/synthesis.md

Then for each persona below, read their full files and verify:
1. Do synthesis claims about this persona match the source data?
2. Are quoted statements accurate?
3. Are quantitative figures (NPS, revenue, retention) correct?
4. Is the persona's verdict correctly attributed?
${check_files}

Write a verification report to: ${study_dir}/verification.md

Format:
# Spot-Check Verification

Checked personas: [list IDs]

## Per-Persona Results
For each persona: PASS or DISCREPANCY with specific details.

## Overall
[X/Y personas verified. Summary of any discrepancies found.]" \
        2>&1 | $STREAM_FILTER

    if [ -s "${study_dir}/verification.md" ]; then
        echo "  Verification written to ${study_dir}/verification.md"
    else
        echo "  WARN: Verification was not generated."
    fi
}

# --- Phase: Cross-Synthesis (single call — unified analysis across studies) ---
run_cross_synthesize() {
    local panel_dir="$1"

    # Discover studies with completed synthesis and artifacts
    local synthesis_files=()
    local artifacts_files=()
    for f in "${panel_dir}/studies"/*/synthesis.md; do
        [ -f "$f" ] && synthesis_files+=("$f")
    done
    for f in "${panel_dir}/studies"/*/artifacts.md; do
        [ -f "$f" ] && artifacts_files+=("$f")
    done

    if [ "${#synthesis_files[@]}" -eq 0 ]; then
        echo "ERROR: No synthesis files found in ${panel_dir}/studies/*/. Run studies first."
        return 1
    fi

    local study_count="${#synthesis_files[@]}"

    # Count personas
    local persona_count
    persona_count=$(count_files "${panel_dir}/personas" "persona-*.md")

    # Build persona context: summaries if >30, full paths if <=30
    local persona_instruction
    if [ "$persona_count" -gt 30 ]; then
        local summaries=""
        for pfile in "${panel_dir}/personas"/persona-*.md; do
            [ -f "$pfile" ] || continue
            summaries="${summaries}
$(extract_persona_summary "$pfile")"
        done
        persona_instruction="Persona summaries (${persona_count} personas):
${summaries}

For persona arc tracking, use these summaries to identify personas by name and number."
    else
        persona_instruction="Read ALL persona background files in: ${panel_dir}/personas/
Use full persona backgrounds for arc tracking."
    fi

    echo ""
    update_status "$panel_dir" "cross-synthesize" "started"

    echo "╔═══════════════════════════════════════════════╗"
    echo "║  CROSS-STUDY SYNTHESIS                           ║"
    echo "║  Studies: ${study_count}, Personas: ${persona_count}                      ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""

    mkdir -p "${panel_dir}/.templates"
    local cross_synthesis_template="${panel_dir}/.templates/cross-synthesis.md"
    if [ ! -f "$cross_synthesis_template" ]; then
        ensure_version_locked_template "${SCRIPT_DIR}/templates/cross-synthesis.md" "$cross_synthesis_template"
    fi

    FACET_PHASE="Cross-synthesis: ${study_count} studies" \
    claude --print --verbose --output-format stream-json \
        --max-turns 50 \
        --allowedTools "Read,Write,Glob,Grep" \
        -p "You are running the Cross-Study Synthesis phase of a Facet behavioral simulation study.

Read these files for context:
1. Cross-synthesis template (follow these instructions): ${cross_synthesis_template}

Then read ALL per-study synthesis files:
$(for f in "${synthesis_files[@]}"; do echo "- $f"; done)

Then read ALL per-study artifacts files:
$(for f in "${artifacts_files[@]}"; do echo "- $f"; done)

${persona_instruction}

Produce a unified cross-study synthesis connecting findings across all ${study_count} studies.
Write the cross-synthesis to: ${panel_dir}/cross-synthesis.md" \
        2>&1 | $STREAM_FILTER

    if [ ! -s "${panel_dir}/cross-synthesis.md" ]; then
        echo "ERROR: Cross-synthesis was not generated."
        return 1
    fi

    echo ""
    echo "Cross-synthesis written to ${panel_dir}/cross-synthesis.md"
    update_status "$panel_dir" "cross-synthesize" "complete"
}

# --- Show status ---
show_status() {
    local panel_dir="$1"
    local status_file="${panel_dir}/.status"

    echo ""
    echo "Study: $(basename "$panel_dir")"
    echo "---"

    # Persona count
    local persona_count=0
    if [ -d "${panel_dir}/personas" ]; then
        persona_count=$(count_files "${panel_dir}/personas" "persona-*.md")
    fi
    echo "Personas generated: ${persona_count}"

    # List studies
    if [ -d "${panel_dir}/studies" ]; then
        echo ""
        echo "Studies:"
        for study_entry in "${panel_dir}/studies"/*/; do
            if [ -d "$study_entry" ]; then
                local ename
                ename=$(basename "$study_entry")
                local sim_count=0
                if [ -d "${study_entry}/simulations" ]; then
                    sim_count=$(count_files "${study_entry}/simulations" "persona-*.md")
                fi
                local has_synthesis="no"
                [ -f "${study_entry}/synthesis.md" ] && has_synthesis="yes"
                local has_artifacts="no"
                [ -f "${study_entry}/artifacts.md" ] && has_artifacts="yes"
                echo "  ${ename}: ${sim_count} simulations, synthesis: ${has_synthesis}, artifacts: ${has_artifacts}"
            fi
        done
    else
        echo "Studies: none"
    fi

    # Cross-synthesis status
    if [ -f "${panel_dir}/cross-synthesis.md" ]; then
        local cs_lines
        cs_lines=$(wc -l < "${panel_dir}/cross-synthesis.md" | tr -d ' ')
        echo ""
        echo "Cross-synthesis: yes (${cs_lines} lines)"
    elif [ -d "${panel_dir}/studies" ]; then
        local synth_count=0
        for f in "${panel_dir}/studies"/*/synthesis.md; do
            [ -f "$f" ] && ((synth_count++)) || true
        done
        if [ "$synth_count" -gt 0 ]; then
            echo ""
            echo "Cross-synthesis: not yet (${synth_count} study syntheses ready)"
            echo "  Run: ./sim.sh synthesize --panel ${panel_dir}"
        fi
    fi

    # Phase history
    if [ -f "$status_file" ]; then
        echo ""
        echo "Phase history:"
        python3 -c "
import json, sys
for line in sys.stdin:
    line = line.strip()
    if not line: continue
    try:
        obj = json.loads(line)
        print(f\"  {obj.get('phase','?')}: {obj.get('status','?')} ({obj.get('timestamp','?')})\")
    except json.JSONDecodeError:
        pass
" < "$status_file"
    fi

    # Also show study-level status
    if [ -d "${panel_dir}/studies" ]; then
        for study_entry in "${panel_dir}/studies"/*/; do
            local estatus="${study_entry}.status"
            if [ -f "$estatus" ]; then
                echo ""
                echo "  Study: $(basename "$study_entry")"
                python3 -c "
import json, sys
for line in sys.stdin:
    line = line.strip()
    if not line: continue
    try:
        obj = json.loads(line)
        print(f\"    {obj.get('phase','?')}: {obj.get('status','?')} ({obj.get('timestamp','?')})\")
    except json.JSONDecodeError:
        pass
" < "$estatus"
            fi
        done
    fi

    echo ""
    echo "Output files:"
    for f in plan.md cross-synthesis.md; do
        if [ -f "${panel_dir}/$f" ]; then
            local lines
            lines=$(wc -l < "${panel_dir}/$f" | tr -d ' ')
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

    local config="" panel_dir="" panel_dir2="" study_name="" concurrency="5" calibration="" continue_on_error="false" runs="1" output_dir=""

    while [ $# -gt 0 ]; do
        case "$1" in
            --config) config="$2"; shift 2 ;;
            --panel) panel_dir="$2"; shift 2 ;;
            --panel2) panel_dir2="$2"; shift 2 ;;
            --name) study_name="$2"; shift 2 ;;
            --concurrency) concurrency="$2"; shift 2 ;;
            --calibration) calibration="$2"; shift 2 ;;
            --continue-on-error) continue_on_error="true"; shift ;;
            --runs) runs="$2"; shift 2 ;;
            --output-dir) output_dir="$2"; shift 2 ;;
            *) echo "Unknown argument: $1"; exit 1 ;;
        esac
    done

    # Resolve output_dir to absolute path
    if [ -n "$output_dir" ] && [[ "$output_dir" != /* ]]; then
        mkdir -p "$output_dir" 2>/dev/null || true
        output_dir="$(cd "$output_dir" 2>/dev/null && pwd || realpath "$output_dir" 2>/dev/null || echo "$(pwd)/$output_dir")"
    fi

    # Validate calibration path if provided (file or directory)
    local cal_file_count=0
    if [ -n "$calibration" ]; then
        if [[ "$calibration" != /* ]]; then
            calibration="${SCRIPT_DIR}/${calibration}"
        fi
        if [ -d "$calibration" ]; then
            # Directory — check it's not empty
            cal_file_count=$(find "$calibration" -type f \( -name "*.md" -o -name "*.csv" -o -name "*.txt" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | wc -l | tr -d ' ')
            if [ "$cal_file_count" -eq 0 ]; then
                echo "ERROR: Calibration directory has no readable files (.md/.csv/.txt/.json/.yaml): $calibration"
                exit 1
            fi
            echo "Calibration: directory with ${cal_file_count} files"
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

    # Derive panel_dir from config if not provided
    if [ -z "$panel_dir" ] && [ -n "$config" ]; then
        if [ -z "$study_name" ]; then
            # Try to extract a study_name field from the config frontmatter
            study_name=$(parse_frontmatter "$config" "study_name" 2>/dev/null || true)
            if [ -z "$study_name" ]; then
                study_name=$(basename "$config" .md)
                # Strip common suffixes for cleaner directory names
                study_name="${study_name%-product}"
                study_name="${study_name%-config}"
                study_name="${study_name%-study}"
            fi
        fi
        local base_dir="${output_dir:-${SCRIPT_DIR}/output}"
        panel_dir="${base_dir}/${study_name}"
    fi

    # Resolve panel_dir to absolute path
    if [ -n "$panel_dir" ] && [[ "$panel_dir" != /* ]]; then
        panel_dir="${SCRIPT_DIR}/${panel_dir}"
    fi

    case "$cmd" in
        init)
            [ -z "$config" ] && { echo "Usage: ./sim.sh init --config <product-config> [--name <name>] [--concurrency N] [--calibration <file>]"; exit 1; }

            local total_personas
            total_personas=$(( $(parse_frontmatter "$config" "segments") * $(parse_frontmatter "$config" "personas_per_segment") ))
            local resume_init="false"

            local existing_personas=0
            if [ -d "${panel_dir}/personas" ]; then
                existing_personas=$(count_files "${panel_dir}/personas" "persona-*.md")
            fi

            if [ "$existing_personas" -gt "$total_personas" ]; then
                echo "ERROR: Found ${existing_personas} personas in ${panel_dir}/, but config expects ${total_personas}."
                echo "  Use a different --name or remove the extra persona files before rerunning init."
                exit 1
            fi

            # Overwrite protection: refuse to init into a completed panel, but allow
            # resuming partial persona generation after transient failures.
            if [ -f "${panel_dir}/plan.md" ]; then
                if [ "$existing_personas" -eq "$total_personas" ]; then
                    echo "ERROR: Study already exists at ${panel_dir}/"
                    echo "  Existing plan: ${panel_dir}/plan.md"
                    echo "  To re-run, use a different --name or delete the existing study."
                    exit 1
                fi
                resume_init="true"
                echo "Resuming existing panel at ${panel_dir}/ (${existing_personas}/${total_personas} personas already generated)"
            elif [ "$existing_personas" -gt 0 ]; then
                echo "ERROR: Found persona files in ${panel_dir}/personas/ but no plan.md."
                echo "  Remove the partial output or restore the plan before rerunning init."
                exit 1
            fi

            mkdir -p "${panel_dir}/personas"

            # Version-lock init-phase templates
            version_lock_study_templates "$panel_dir"
            echo "Templates version-locked to ${panel_dir}/.templates/"

            echo ""
            echo "FACET SIMULATION ENGINE v2"
            echo "Config: $(basename "$config")"
            echo "Output: ${panel_dir}"
            if [ -n "$calibration" ]; then
                if [ -d "$calibration" ]; then
                    echo "Calibration: $(basename "$calibration")/ (${cal_file_count} files)"
                else
                    echo "Calibration: $(basename "$calibration")"
                fi
            fi
            estimate_time "$total_personas" 0 "$concurrency" "$output_dir"
            echo ""
            if [ "$resume_init" = "true" ]; then
                echo "Reusing existing plan at ${panel_dir}/plan.md"
            else
                run_plan "$config" "$panel_dir" "$calibration"
            fi
            run_generate "$config" "$panel_dir" "$concurrency" "$calibration"
            echo ""
            echo "INIT COMPLETE — panel ready for studies"
            echo "Output: ${panel_dir}/"
            echo ""
            echo "Next: ./sim.sh study --panel ${panel_dir} --config <study-config>"
            ;;
        study)
            [ -z "$panel_dir" ] && { echo "Usage: ./sim.sh study --panel <dir> --config <study-config> [--concurrency N]"; exit 1; }
            [ -z "$config" ] && { echo "Usage: ./sim.sh study --panel <dir> --config <study-config> [--concurrency N]"; exit 1; }

            if [ ! -d "${panel_dir}/personas" ]; then
                echo "ERROR: No personas directory at ${panel_dir}/personas/. Run 'init' first."
                exit 1
            fi

            local study_name
            study_name=$(parse_frontmatter "$config" "study_name")
            if [ -z "$study_name" ]; then
                study_name=$(basename "$config" .md)
            fi

            local study_dir="${panel_dir}/studies/${study_name}"
            mkdir -p "${study_dir}/simulations"

            # Copy study config into the study directory for reference
            cp "$config" "${study_dir}/study-config.md"

            # Version-lock study-phase templates + study-type rules
            local study_type
            study_type=$(parse_frontmatter "$config" "study_type")
            version_lock_study_phase_templates "$study_dir" "$study_type"
            echo "Templates version-locked to ${study_dir}/.templates/"

            local ex_persona_count
            ex_persona_count=$(count_files "${panel_dir}/personas" "persona-*.md")

            echo ""
            echo "FACET SIMULATION ENGINE v2"
            echo "Study: $(basename "$panel_dir")"
            echo "Study: ${study_name}"
            echo "Config: $(basename "$config")"
            estimate_time "$ex_persona_count" 1 "$concurrency" "$output_dir"
            echo ""

            if [ "$runs" -gt 1 ]; then
                # Stability testing: run simulate N times, then compare
                echo "Stability testing: ${runs} runs"
                echo ""

                for run_num in $(seq 1 "$runs"); do
                    local run_sim_dir="${study_dir}/simulations"
                    local run_log_dir="${study_dir}/logs"
                    if [ "$run_num" -gt 1 ]; then
                        run_sim_dir="${study_dir}/simulations-run-${run_num}"
                        run_log_dir="${study_dir}/logs-run-${run_num}"
                    fi

                    echo "Run ${run_num}/${runs}:"
                    prepare_run_outputs "$run_sim_dir" "$run_log_dir"
                    run_simulate "$panel_dir" "$config" "$study_dir" "$concurrency" "$run_sim_dir" "$run_log_dir"
                done

                # Run analysis on the first run's simulations
                run_analyze "$panel_dir" "$config" "$study_dir"

                # Generate stability report
                echo ""
                echo "Generating stability report..."

                local sim_dirs_list=""
                sim_dirs_list="- ${study_dir}/simulations/"
                for run_num in $(seq 2 "$runs"); do
                    sim_dirs_list="${sim_dirs_list}
- ${study_dir}/simulations-run-${run_num}/"
                done

                FACET_PHASE="Stability report: ${runs} runs" \
                claude --print --verbose --output-format stream-json \
                    --max-turns 30 \
                    --allowedTools "Read,Write,Glob,Grep" \
                    -p "You are generating a stability report for a Facet simulation study.

Read these files for context:
1. Stability template: ${SCRIPT_DIR}/templates/stability.md
2. Study config: ${config}

The study was run ${runs} times with the same personas. Read simulation files from each run:
${sim_dirs_list}

Compare per-persona verdicts across runs.
Write the stability report to: ${study_dir}/stability-report.md" \
                    2>&1 | $STREAM_FILTER

                echo ""
                echo "STUDY COMPLETE (stability testing: ${runs} runs)"
                echo "Results: ${study_dir}/"
                echo "  synthesis.md — analysis from run 1"
                echo "  stability-report.md — per-persona consistency across ${runs} runs"
            else
                run_simulate "$panel_dir" "$config" "$study_dir" "$concurrency"
                run_analyze "$panel_dir" "$config" "$study_dir"

                echo ""
                echo "STUDY COMPLETE"
                echo "Results: ${study_dir}/"
                echo "  synthesis.md — analysis + recommendation + counterargument"
                echo "  artifacts.md — actionable deliverables"
                echo "  simulations/ — per-persona simulation details"
            fi
            ;;
        synthesize)
            [ -z "$panel_dir" ] && { echo "Usage: ./sim.sh synthesize --panel <dir>"; exit 1; }

            if [ ! -d "${panel_dir}/studies" ]; then
                echo "ERROR: No studies directory at ${panel_dir}/studies/. Run studies first."
                exit 1
            fi

            echo ""
            echo "FACET SIMULATION ENGINE v2"
            echo "Study: $(basename "$panel_dir")"
            echo ""

            run_cross_synthesize "$panel_dir"

            echo ""
            echo "CROSS-SYNTHESIS COMPLETE"
            echo "Results: ${panel_dir}/cross-synthesis.md"
            ;;
        compare)
            [ -z "$panel_dir" ] && { echo "Usage: ./sim.sh compare --panel <dir1> --panel2 <dir2>"; exit 1; }
            [ -z "$panel_dir2" ] && { echo "Usage: ./sim.sh compare --panel <dir1> --panel2 <dir2>"; exit 1; }

            # Resolve panel_dir2 to absolute path
            if [[ "$panel_dir2" != /* ]]; then
                panel_dir2="${SCRIPT_DIR}/${panel_dir2}"
            fi

            # Collect synthesis files from both studies
            local study_a_files="" study_b_files=""

            if [ -f "${panel_dir}/cross-synthesis.md" ]; then
                study_a_files="${panel_dir}/cross-synthesis.md"
            else
                for f in "${panel_dir}/studies"/*/synthesis.md; do
                    [ -f "$f" ] && study_a_files="${study_a_files}
- $f"
                done
            fi

            if [ -f "${panel_dir2}/cross-synthesis.md" ]; then
                study_b_files="${panel_dir2}/cross-synthesis.md"
            else
                for f in "${panel_dir2}/studies"/*/synthesis.md; do
                    [ -f "$f" ] && study_b_files="${study_b_files}
- $f"
                done
            fi

            if [ -z "$study_a_files" ] || [ -z "$study_b_files" ]; then
                echo "ERROR: Both studies need synthesis files (run studies or synthesize first)."
                exit 1
            fi

            echo ""
            echo "╔═══════════════════════════════════════════════╗"
            echo "║  STUDY COMPARISON                              ║"
            echo "║  A: $(basename "$panel_dir")"
            echo "║  B: $(basename "$panel_dir2")"
            echo "╚═══════════════════════════════════════════════╝"
            echo ""

            local compare_output="${panel_dir}/comparison-vs-$(basename "$panel_dir2").md"

            FACET_PHASE="Comparison: $(basename "$panel_dir") vs $(basename "$panel_dir2")" \
            claude --print --verbose --output-format stream-json \
                --max-turns 30 \
                --allowedTools "Read,Write,Glob,Grep" \
                -p "You are comparing two Facet simulation studies.

Read these files for context:
1. Comparison template (follow these instructions): ${SCRIPT_DIR}/templates/comparison.md

Study A ($(basename "$panel_dir")):
${study_a_files}

Study B ($(basename "$panel_dir2")):
${study_b_files}

Read all listed synthesis files from both studies, then produce a comparison.
Write the comparison to: ${compare_output}" \
                2>&1 | $STREAM_FILTER

            if [ ! -s "$compare_output" ]; then
                echo "ERROR: Comparison was not generated."
                exit 1
            fi

            echo ""
            echo "COMPARISON COMPLETE"
            echo "Results: ${compare_output}"
            ;;
        run)
            [ -z "$config" ] && { echo "Usage: ./sim.sh run --config <study-config> [--name <name>] [--concurrency N] [--continue-on-error]"; exit 1; }

            # Parse study config
            local segments per_segment study_calibration
            segments=$(parse_frontmatter "$config" "segments")
            per_segment=$(parse_frontmatter "$config" "personas_per_segment")
            study_calibration=$(parse_frontmatter "$config" "calibration")

            if [ -z "$segments" ] || [ -z "$per_segment" ]; then
                echo "ERROR: Study config must have 'segments' and 'personas_per_segment' in frontmatter."
                exit 1
            fi

            # Get study list from config
            local study_configs
            study_configs=$(python3 "${SCRIPT_DIR}/parse_config.py" "$config" "studies" --list)
            if [ -z "$study_configs" ]; then
                echo "ERROR: Run config must have 'studies' array in frontmatter."
                exit 1
            fi

            # Extract product body to temp file
            local product_config
            product_config=$(mktemp "${TMPDIR:-/tmp}/facet-product-XXXXXXXX.md")
            trap "rm -f '$product_config'" EXIT

            # Write frontmatter + body as product config
            echo "---" > "$product_config"
            echo "segments: ${segments}" >> "$product_config"
            echo "personas_per_segment: ${per_segment}" >> "$product_config"
            echo "---" >> "$product_config"
            python3 "${SCRIPT_DIR}/parse_config.py" "$config" --body >> "$product_config"

            # Resolve calibration path relative to study config
            if [ -n "$study_calibration" ]; then
                if [[ "$study_calibration" != /* ]]; then
                    study_calibration="$(dirname "$config")/${study_calibration}"
                fi
                calibration="$study_calibration"
            fi

            # Resolve study config paths relative to study config
            local config_dir
            config_dir=$(dirname "$config")

            local study_count=0
            while IFS= read -r line; do
                ((study_count++)) || true
            done <<< "$study_configs"

            echo ""
            echo "╔═══════════════════════════════════════════════╗"
            echo "║  FACET STUDY                                   ║"
            echo "║  Studies: ${study_count}, Personas: $((segments * per_segment))                     ║"
            echo "╚═══════════════════════════════════════════════╝"
            estimate_time "$((segments * per_segment))" "$study_count" "$concurrency" "$output_dir"
            echo ""

            # Phase 1: Init (skip only when the study inputs are complete)
            local persona_count=0
            local expected_persona_count=$((segments * per_segment))
            if [ -d "${panel_dir}/personas" ]; then
                persona_count=$(count_files "${panel_dir}/personas" "persona-*.md")
            fi

            version_lock_study_templates "$panel_dir"

            if [ "$persona_count" -gt "$expected_persona_count" ]; then
                echo "ERROR: Found ${persona_count} personas in ${panel_dir}, but study config expects ${expected_persona_count}."
                echo "Use a fresh output directory or remove the extra persona files before resuming."
                exit 1
            fi

            if [ "$persona_count" -eq "$expected_persona_count" ] && [ -f "${panel_dir}/plan.md" ]; then
                echo "Skipping init: ${persona_count}/${expected_persona_count} personas already exist and plan.md is present"
                echo ""
            else
                mkdir -p "${panel_dir}/personas"
                if [ "$persona_count" -gt 0 ] || [ -f "${panel_dir}/plan.md" ]; then
                    echo "Resuming init: ${persona_count}/${expected_persona_count} personas ready"
                fi

                run_plan "$product_config" "$panel_dir" "$calibration"
                run_generate "$product_config" "$panel_dir" "$concurrency" "$calibration"
            fi

            # Phase 2: Run each study
            local study_num=0
            local study_failures=0
            while IFS= read -r study_config_path; do
                ((study_num++)) || true

                # Resolve relative paths
                if [[ "$study_config_path" != /* ]]; then
                    study_config_path="${config_dir}/${study_config_path}"
                fi

                if [ ! -f "$study_config_path" ]; then
                    echo "ERROR: Study config not found: $study_config_path"
                    if [ "$continue_on_error" = "true" ]; then
                        ((study_failures++)) || true
                        continue
                    else
                        exit 1
                    fi
                fi

                local ex_name
                ex_name=$(parse_frontmatter "$study_config_path" "study_name")
                [ -z "$ex_name" ] && ex_name=$(basename "$study_config_path" .md)

                local ex_dir="${panel_dir}/studies/${ex_name}"

                # Skip if already completed (resumability)
                if [ -f "${ex_dir}/synthesis.md" ]; then
                    echo "Skipping study ${study_num}/${study_count}: ${ex_name} (already completed)"
                    continue
                fi

                echo ""
                echo "Study ${study_num}/${study_count}: ${ex_name}"
                echo "---"

                # Set up study directory and version-lock templates
                mkdir -p "${ex_dir}/simulations"
                cp "$study_config_path" "${ex_dir}/study-config.md"

                local ex_study_type
                ex_study_type=$(parse_frontmatter "$study_config_path" "study_type")
                version_lock_study_phase_templates "$ex_dir" "$ex_study_type"

                if ! run_simulate "$panel_dir" "$study_config_path" "$ex_dir" "$concurrency"; then
                    echo "WARNING: Simulation failed for ${ex_name}"
                    if [ "$continue_on_error" = "true" ]; then
                        ((study_failures++)) || true
                        continue
                    else
                        exit 1
                    fi
                fi

                if ! run_analyze "$panel_dir" "$study_config_path" "$ex_dir"; then
                    echo "WARNING: Analysis failed for ${ex_name}"
                    if [ "$continue_on_error" = "true" ]; then
                        ((study_failures++)) || true
                        continue
                    else
                        exit 1
                    fi
                fi
            done <<< "$study_configs"

            # Phase 3: Cross-synthesis (skip if all studies failed)
            if [ "$study_failures" -lt "$study_count" ]; then
                echo ""
                run_cross_synthesize "$panel_dir"
            else
                echo ""
                echo "WARNING: All ${study_count} studies failed. Skipping cross-synthesis."
            fi

            echo ""
            echo "╔═══════════════════════════════════════════════╗"
            echo "║  STUDY COMPLETE                                ║"
            echo "╚═══════════════════════════════════════════════╝"
            echo ""
            echo "Results: ${panel_dir}/"
            echo "  cross-synthesis.md — unified findings across all studies"
            if [ "$study_failures" -gt 0 ]; then
                echo "  WARNING: ${study_failures} study(s) failed"
            fi
            echo ""
            echo "Per-study results in studies/*/"
            ;;
        status)
            [ -z "$panel_dir" ] && { echo "Usage: ./sim.sh status --panel <dir>"; exit 1; }
            show_status "$panel_dir"
            ;;
        help|--help|-h)
            echo "Facet v2 — Pre-Launch Simulation Engine"
            echo ""
            echo "Usage:"
            echo "  ./sim.sh init        --config <product-config> [--name <name>] [--concurrency N] [--calibration <file>]"
            echo "  ./sim.sh study       --panel <dir> --config <study-config> [--concurrency N] [--runs N]"
            echo "  ./sim.sh synthesize  --panel <dir>"
            echo "  ./sim.sh compare     --panel <dir1> --panel2 <dir2>"
            echo "  ./sim.sh run         --config <full-study-config> [--name <name>] [--concurrency N] [--continue-on-error]"
            echo "  ./sim.sh status      --panel <dir>"
            echo ""
            echo "Commands:"
            echo "  init        Create a research panel: plan + generate persona backgrounds"
            echo "  study       Run a study against a panel: simulate + analyze"
            echo "  synthesize  Cross-study synthesis (unified findings across all studies)"
            echo "  compare     Compare findings between two panels"
            echo "  run         Full lifecycle: init panel + all studies + synthesize"
            echo "  status      Show panel and study progress"
            echo ""
            echo "Options:"
            echo "  --config      Path to config file (product config for init, study config for study)"
            echo "  --name        Panel name (default: config filename without .md)"
            echo "  --panel       Path to panel output directory"
            echo "  --concurrency Number of parallel generations/simulations (default: 5)"
            echo "  --calibration Path to calibration data file OR directory"
            echo "  --continue-on-error Skip failed studies instead of halting (run command only)"
            echo "  --runs        Number of simulation runs for stability testing (default: 1)"
            echo ""
            echo "Workflow:"
            echo "  1. Create a product config (see examples/superhuman-product.md)"
            echo "  2. ./sim.sh init --config examples/superhuman-product.md --name superhuman"
            echo "  3. Create study configs (see examples/superhuman-pricing.md)"
            echo "  4. ./sim.sh study --panel output/superhuman/ --config examples/superhuman-pricing.md"
            echo "  5. Run more studies against the same panel:"
            echo "     ./sim.sh study --panel output/superhuman/ --config examples/superhuman-copy.md"
            echo "  6. Produce cross-study synthesis:"
            echo "     ./sim.sh synthesize --panel output/superhuman/"
            ;;
        *)
            echo "Unknown command: $cmd"
            echo "Run './sim.sh help' for usage."
            exit 1
            ;;
    esac
}

main "$@"
