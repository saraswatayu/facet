You are running **Facet Run** — simulating personas through a product exercise and producing analysis.

## Arguments

$ARGUMENTS

Expected: `<study-dir> <exercise-config-path> [--concurrency <N>]`

- Study directory is required (e.g., `output/superhuman/`). Must contain `personas/` with generated persona files.
- Exercise config path is required (e.g., `examples/superhuman-pricing.md`).
- `--concurrency` sets parallel simulation limit (default: 5)

If arguments are missing, ask the user.

## Setup

1. Verify `{study_dir}/personas/` exists and contains persona files
2. Read the exercise config
3. Parse YAML frontmatter for `exercise_name`, `study_type`, `options`
4. Set exercise dir to `{study_dir}/exercises/{exercise_name}/`
5. Create `{exercise_dir}/simulations/` and `{exercise_dir}/.templates/`
6. Copy exercise config to `{exercise_dir}/exercise.md`
7. Copy `templates/simulation.md` and `templates/analysis.md` to `{exercise_dir}/.templates/`
8. If `study-types/{study_type}.md` exists, copy it to `{exercise_dir}/.templates/`
9. Count persona files

Report:

```
FACET RUN
Study: {study name}
Exercise: {exercise_name}
Type: {study_type}
Personas: {N}
```

## Phase 1: Simulation (parallel)

Spawn one Agent per persona using the **Agent tool** for context isolation. Each persona MUST be a separate agent — this prevents contamination between simulations.

For each persona file in `{study_dir}/personas/persona-*.md`:

Spawn an Agent:
- `model: "sonnet"`
- `description: "Simulate {persona-NNN}"`
- `mode: "bypassPermissions"`
- Prompt:
  ```
  You are simulating persona {basename} through an exercise for a behavioral simulation study.

  Read these files:
  1. Persona background: {persona_file_path}
  2. Exercise config: {exercise_config_path}
  3. Simulation template: templates/simulation.md
  4. Study type rules: study-types/{study_type}.md

  Generate this persona's reactions to the options in the exercise config.
  Stay completely in character — use the persona's voice, vocabulary, and decision-making patterns.

  Write the simulation to: {exercise_dir}/simulations/{basename}.md
  ```

Launch agents in parallel batches (up to concurrency limit). Use a single message with multiple Agent tool calls per batch.

After all simulations:
- Count completed simulation files
- Report: `Simulation complete: {completed}/{total}`
- Note any failures

## Phase 2: Analysis

This phase runs directly — NOT as a sub-agent — because it needs to synthesize ALL personas and simulations together.

1. Read `templates/analysis.md` for instructions
2. Read the exercise config
3. Read ALL persona files in `{study_dir}/personas/`
4. Read ALL simulation files in `{exercise_dir}/simulations/`
5. Follow the analysis template instructions to produce TWO files:
   - `{exercise_dir}/synthesis.md` — findings, recommendations, counterargument, sycophancy audit, pre-mortem
   - `{exercise_dir}/artifacts.md` — actionable deliverables, validation plan

This is the most important phase. Take your time. Read every file. The analysis template has detailed instructions — follow them exactly.

## Completion

Report:

```
EXERCISE COMPLETE
Results: {exercise_dir}/

  synthesis.md — analysis + recommendation + counterargument
  artifacts.md — actionable deliverables + validation plan
  simulations/ — {N} per-persona simulation details
```

Then give the user a brief (3-5 bullet) summary of the key findings from synthesis.md.

## Rules

- Each simulation agent uses ONLY Read and Write tools
- Deal-breakers from persona backgrounds MUST be honored — not every persona converts
- Simulation agents must stay in character — voice, vocabulary, financial constraints
- The analysis phase runs as the main session, not a sub-agent
- Analysis produces TWO separate files (synthesis.md and artifacts.md), not one combined file
