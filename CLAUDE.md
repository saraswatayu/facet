# Facet v2 — Pre-Launch Simulation Engine

A CLI tool that generates detailed narrative personas and simulates them through product exercises (pricing, copy, features). Produces synthesis with decisive recommendations, actionable artifacts, and adversarial review.

## Architecture

3-phase pipeline, each phase is a `claude` CLI invocation:

```
init: Plan → Generate (parallel)
exercise: Simulate (parallel) → Analyze
```

- **Plan**: Generates JTBD-based segment matrix, persona constraint vectors, cross-reference plan with trust levels, diversity matrix, name registry
- **Generate**: One `claude` call per persona, parallel (configurable concurrency). Each persona gets fresh context with the template + plan. Produces background ONLY (no simulations). Includes behavioral economics profile, deal-breakers, and consistency self-check.
- **Simulate**: One `claude` call per persona per exercise, parallel. Reads persona background + exercise config. Produces option simulations with Chain-of-Feeling decision arcs, BDI-structured verdicts, Referral Story Travelability Scores, copy reactions.
- **Analyze**: Single call reads all personas + all simulations. Produces synthesis (with confidence grading, behavioral mechanism analysis, stated vs revealed preference gap, sycophancy audit, pre-mortem) + artifacts (with validation plan) + counterargument (with LLM bias audit, alternative recommendation).

Key design: personas are generated ONCE and reused across multiple exercises. A pricing exercise and a copy exercise share the same persona backgrounds.

## Research-Grounded Design

Templates incorporate findings from ~490 academic sources:
- **Anti-sycophancy**: Integrity rules at every phase. LLMs default to agreement (Sharma et al., ICLR 2024); templates explicitly permit and encourage rejection/skepticism.
- **Behavioral economics**: Explicit parameters per persona (reference point, loss aversion, mental accounting, subscription fatigue, status quo bias). LLMs produce human-like biases only 17-57% of the time without explicit instruction.
- **Diversity enforcement**: Constraint vectors with Big Five scores, JTBD segments, diversity matrix with 50% concentration threshold, counter-stereotypical detail quota (40%).
- **Confidence calibration**: Every finding gets HIGH/MODERATE/LOW confidence. Disclosure header on every synthesis. Known limitations per study type.
- **Validation plan**: Every synthesis includes recommended real-user validation steps.

## Key Files

- `sim.sh` — Main orchestrator. Subcommands: `init`, `exercise`, `status`
- `stream_filter.py` — Parses `--output-format stream-json` for real-time progress display
- `templates/` — Prompt templates for each phase
  - `plan.md` — Planning instructions (JTBD segments, constraint vectors, diversity matrix, cross-references)
  - `persona.md` — Persona background generation (integrity rules, verbalized sampling, behavioral economics profile, consistency check)
  - `simulation.md` — Per-persona exercise simulation (Chain-of-Feeling, BDI verdicts, integrity rules)
  - `analysis.md` — Unified analysis producing TWO files: synthesis.md (Parts 1+3) and artifacts.md (Part 2)
- `study-types/` — Simulation rules per study type (pricing, copy, features)
- `examples/` — Example configs (product configs + exercise configs)
- `research/` — Research reports (~490 sources) informing template design
- `output/` — Generated studies (gitignored)

## Output Structure

```
output/{product}/
├── .templates/                     # version-locked init templates
│   ├── plan.md
│   └── persona.md
├── plan.md                         # JTBD segments, constraint vectors, diversity matrix
├── personas/                       # generated ONCE, reusable
│   ├── persona-001.md              # identity, psychology, behavioral economics, discovery
│   └── ...
└── exercises/
    └── {exercise-name}/
        ├── .templates/             # version-locked exercise templates
        │   ├── simulation.md
        │   ├── analysis.md
        │   └── {study-type}.md
        ├── exercise.md             # copy of exercise config
        ├── simulations/
        │   ├── persona-001.md      # Chain-of-Feeling arcs, BDI verdicts
        │   └── ...
        ├── synthesis.md            # analysis + recommendation + counterargument
        └── artifacts.md            # actionable deliverables + validation plan
```

## Config Format

Two types of config:

**Product config** (for `init`): Markdown with YAML frontmatter containing `segments` and `personas_per_segment`. Body has product description, key details, target market.

**Exercise config** (for `exercise`): Markdown with YAML frontmatter containing `exercise_name`, `study_type`, `options`, and optionally `copy_variants`. Body has options detail and copy variants.

## CLI Usage

```bash
# Initialize: plan + generate persona backgrounds
./sim.sh init --config examples/perch-product.md --name perch

# Initialize with calibration data (single file)
./sim.sh init --config examples/perch-product.md --name perch --calibration real-survey-data.md

# Initialize with calibration data directory (multiple files)
./sim.sh init --config examples/perch-product.md --name perch --calibration ./research-data/

# Run exercises against existing personas
./sim.sh exercise --study output/perch/ --config examples/perch-pricing.md
./sim.sh exercise --study output/perch/ --config examples/perch-copy.md
./sim.sh exercise --study output/perch/ --config examples/perch-features.md

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
- Persona outlines in plan.md use `Persona #N` numbered format (sim.sh depends on this)
- Simulations are per-exercise in `output/{product}/exercises/{name}/simulations/`
- All numbers in personas/simulations must be specific and internally consistent
- Names must be unique across the entire study (enforced by plan.md name registry)
- Template sections adapt to product domain (not hardcoded to travel/flights)
- Templates are version-locked into `.templates/` directories at init and exercise time
- Analysis produces TWO files: synthesis.md and artifacts.md (not one combined file)
