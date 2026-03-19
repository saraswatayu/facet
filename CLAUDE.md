# Facet v2 — Pre-Launch Simulation Engine

A CLI tool that generates detailed narrative personas and simulates them through product exercises (pricing, copy, features). Produces synthesis with decisive recommendations, actionable artifacts, and adversarial review.

## Architecture

3-phase pipeline, each phase is a `claude` CLI invocation:

```
init: Plan → Generate (parallel)
exercise: Simulate (parallel) → Analyze
```

- **Plan**: Generates segment matrix, persona outlines, cross-reference plan, name registry
- **Generate**: One `claude` call per persona, parallel (configurable concurrency). Each persona gets fresh context with the template + plan. Produces background ONLY (no simulations).
- **Simulate**: One `claude` call per persona per exercise, parallel. Reads persona background + exercise config. Produces option simulations, verdicts, copy reactions.
- **Analyze**: Single call reads all personas + all simulations. Produces synthesis + artifacts + counterargument.

Key design: personas are generated ONCE and reused across multiple exercises. A pricing exercise and a copy exercise share the same persona backgrounds.

## Key Files

- `sim.sh` — Main orchestrator. Subcommands: `init`, `exercise`, `status`
- `stream_filter.py` — Parses `--output-format stream-json` for real-time progress display
- `templates/` — Prompt templates for each phase
  - `plan.md` — Planning instructions (segments, outlines, cross-references)
  - `persona.md` — Persona background generation (identity, psychology, domain, discovery)
  - `simulation.md` — Per-persona exercise simulation (options, verdicts, copy reactions)
  - `analysis.md` — Unified analysis (synthesis + artifacts + counterargument)
- `study-types/` — Simulation rules per study type (pricing, copy, features)
- `examples/` — Example configs (product configs + exercise configs)
- `output/` — Generated studies (gitignored)

## Output Structure

```
output/{product}/
├── plan.md                         # segment matrix, persona outlines
├── personas/                       # generated ONCE, reusable
│   ├── persona-001.md              # identity, psychology, domain, discovery
│   └── ...
└── exercises/
    └── {exercise-name}/
        ├── exercise.md             # copy of exercise config
        ├── simulations/
        │   ├── persona-001.md      # this persona's reaction to the options
        │   └── ...
        ├── synthesis.md            # analysis + recommendation + counterargument
        └── artifacts.md            # actionable deliverables
```

## Config Format

Two types of config:

**Product config** (for `init`): Markdown with YAML frontmatter containing `segments` and `personas_per_segment`. Body has product description, key details, target market.

**Exercise config** (for `exercise`): Markdown with YAML frontmatter containing `exercise_name`, `study_type`, `options`, and optionally `copy_variants`. Body has options detail and copy variants.

## CLI Usage

```bash
# Initialize: plan + generate persona backgrounds
./sim.sh init --config examples/perch-product.md --name perch

# Run exercises against existing personas
./sim.sh exercise --study output/perch/ --config examples/perch-pricing.md
./sim.sh exercise --study output/perch/ --config examples/perch-copy.md

# Check status
./sim.sh status --study output/perch/
```

## CLI Pattern

```bash
claude --print --verbose --output-format stream-json \
  --max-turns $MAX_TURNS \
  --allowedTools "Read,Write,Glob,Grep" \
  -p "$PROMPT" 2>&1 | python3 -u stream_filter.py
```

Tools restricted to Read, Write, Glob, Grep. No Bash (no escape hatch). Generation and simulation use `--model sonnet` for cost efficiency.

## Conventions

- Personas are markdown files in `output/{product}/personas/`
- Personas contain ONLY backgrounds — no simulations, verdicts, or copy reactions
- Simulations are per-exercise in `output/{product}/exercises/{name}/simulations/`
- All numbers in personas/simulations must be specific and internally consistent
- Names must be unique across the entire study (enforced by plan.md name registry)
- Template sections adapt to product domain (not hardcoded to travel/flights)
