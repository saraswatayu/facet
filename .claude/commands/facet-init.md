You are running **Facet Init** — generating research-grounded personas for a behavioral simulation study.

## Arguments

$ARGUMENTS

Expected: `<product-config-path> [--name <name>] [--concurrency <N>] [--calibration <path>]`

- Product config path is required. If not provided, ask the user.
- `--name` sets the study name (default: config filename, stripping `-product` suffix)
- `--concurrency` sets parallel persona generation limit (default: 5)
- `--calibration` provides real research data to ground personas

## Setup

1. Read the product config file
2. Parse YAML frontmatter for `segments` and `personas_per_segment`
3. Calculate total = segments × personas_per_segment
4. Determine study name from `--name` or config filename
5. Set output dir to `output/{name}/`
6. Create `output/{name}/personas/` and `output/{name}/.templates/`
7. Copy `templates/plan.md` and `templates/persona.md` to `output/{name}/.templates/`

Report:

```
FACET INIT
Config: {filename}
Output: output/{name}/
Segments: {N} × {per_segment} = {total} personas
```

## Phase 1: Planning

Read `templates/plan.md` — follow its instructions exactly to generate a study plan.

Also read the product config for product context. If `--calibration` was provided, read that file and use it to ground the plan in real-world data.

The plan must include:
- JTBD-based segment matrix
- Persona constraint vectors (Big Five, behavioral economics parameters, deal-breakers)
- Cross-reference plan with trust levels
- Diversity matrix with concentration thresholds
- Name registry

Write the plan to `output/{name}/plan.md`.

Tell the user: `Phase 1 complete — plan.md written`

## Phase 2: Persona Generation

Generate personas in waves of 5 using the **Agent tool** for context isolation. Each persona MUST be a separate agent — this prevents contamination between personas.

### Wave loop

For each wave (1-5, 6-10, 11-15, ...):

1. Build diversity context: for wave 1, this is empty. For subsequent waves, read each previously generated persona file and extract a one-line summary (name, segment, key trait, financial situation).

2. For each persona in this wave, spawn an Agent:
   - `model: "sonnet"`
   - `description: "Generate persona {N}/{total}"`
   - `mode: "bypassPermissions"`
   - Prompt:
     ```
     You are generating persona {N} of {total} for a behavioral simulation study.

     Read these files:
     1. Product config: {config_path}
     2. Study plan: output/{name}/plan.md
     3. Persona template: templates/persona.md

     You are generating persona number {N} (persona-{NNN}).
     Find persona #{N} in the plan's persona outlines and generate a full background.

     IMPORTANT: Generate ONLY the background (identity, psychology, domain profile, discovery).
     Do NOT include option simulations, verdicts, or copy reactions.

     {diversity_context if any — "ALREADY GENERATED PERSONAS: ..." block}

     Write the complete persona background to: output/{name}/personas/persona-{NNN}.md
     ```

3. Launch ALL agents in this wave in a single message (parallel execution).

4. Wait for the wave to complete before starting the next wave. This is critical — the next wave needs diversity context from this wave.

5. Report: `Wave {W}/{total_waves}: personas {start}-{end} complete`

### After all waves

- Count completed persona files in `output/{name}/personas/`
- Report failures if any
- Show a quick validation:
  - How many mention deal-breakers
  - How many have behavioral economics profiles

```
INIT COMPLETE
{completed}/{total} personas generated
Output: output/{name}/

Next: /facet-run output/{name}/ examples/{exercise}.md
```

## Rules

- Each persona agent uses ONLY Read and Write tools
- Personas contain ONLY backgrounds — never simulations or verdicts
- If a persona fails to generate, note it but continue
- Do not generate personas inline — always use the Agent tool for isolation
