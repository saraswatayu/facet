# Facet — Codebase Guide

Pre-launch simulation engine: generates research-grounded personas and simulates them through product exercises. See [README.md](README.md) for user-facing docs, positioning, and limitations.

## Architecture

Two-command pipeline, each composed of sequential phases:

```
sim.sh init:     Plan (Opus) → Generate (Sonnet, parallel waves)
sim.sh exercise: Simulate (Sonnet, parallel) → Analyze (Opus)
```

Two interfaces to the same pipeline:
- **sim.sh** — bash orchestrator for terminal/CI use. Each phase is a `claude --print` subprocess.
- **Claude Code skills** — `/facet-init` and `/facet-run` in `.claude/commands/`. Each phase uses the Agent tool for context isolation.

Key design: personas are generated ONCE and reused across multiple exercises.

### Model Routing

| Phase | Model | Why |
|-------|-------|-----|
| Plan | default (Opus) | Reasoning-heavy: segment design, constraint vectors, diversity matrix |
| Generate | `--model sonnet` | Cost efficiency at scale (50 parallel personas) |
| Simulate | `--model sonnet` | Cost efficiency at scale (50 parallel simulations) |
| Analyze | default (Opus) | Synthesis quality: reads all personas + simulations, produces recommendations |

### Tool Restrictions

All `claude` invocations are restricted to `Read,Write,Glob,Grep`. No Bash — no escape hatch. The one exception: calibration directory mode adds Glob and Grep to persona generation (normally Read,Write only).

## Wave-Based Generation

Personas are generated in waves of 5 to prevent homogeneity.

```
Wave 1: personas 1-5   → no diversity context
Wave 2: personas 6-10  → sees summaries of 1-5
Wave 3: personas 11-15 → sees summaries of 1-10
...
```

After each wave completes, `extract_persona_summary()` in sim.sh reads each generated persona and builds a one-line summary (name, segment, key traits). This summary block is injected into the next wave's prompt with explicit instructions: "your persona must sound, think, and decide differently from ALL of the above."

Each wave must fully complete before the next starts — the diversity context depends on it.

## Template Patterns

All four templates (`plan.md`, `persona.md`, `simulation.md`, `analysis.md`) follow consistent patterns:

1. **Integrity rules** — anti-sycophancy guardrails. Every template explicitly permits rejection, skepticism, indifference. "This persona is NOT obligated to like the product."
2. **Quality bar** — specific > generic. "$38,500/year" not "moderate salary." Named neighborhoods, not "urban area."
3. **Thinking steps** — brainstorm/analysis sections marked "do NOT include in output." These prompt Claude to reason before writing but keep the output clean.
4. **Consistency self-check** — templates end with verification that stated facts, numbers, and decisions are internally consistent.

### Study-Type Rules

Each study type in `study-types/` specifies which behavioral economics frameworks apply:

| Study Type | Frameworks | Key Metrics |
|-----------|------------|-------------|
| `pricing.md` | Prospect theory, mental accounting, loss aversion, flat-rate bias, zero-price effect | Signup decision, 12-month usage table, renewal, NPS, referral |
| `copy.md` | ELM (central/peripheral routes), construal level, reactance, framing effects | Clarity, trust, motivation, shareability (0-10 each) |
| `features.md` | Kano model (must-be/performance/attractive/indifferent), feature interaction | Per-feature importance, excitement, WTP delta, usage frequency |
| `onboarding.md` | Endowment effect, IKEA effect, psychological ownership, status quo bias, default effect, Fogg B=MAP | Completion funnel, time-to-value, ownership score, status quo shift rate |
| `retention.md` | Hedonic adaptation, sunk cost, peak-end rule, post-purchase rationalization, trust decay | 12-month satisfaction arc, churn taxonomy, honest vs. passive retention rate |

Each study type also has outcome requirements (e.g., "at least 1 persona should churn," "features study is the weakest use case — surface reactions, not ranked lists").

## Template Version Locking

Templates are copied into `.templates/` directories at init and exercise time:
- `output/{name}/.templates/` gets `plan.md` + `persona.md` at init
- `output/{name}/exercises/{exercise}/.templates/` gets `simulation.md` + `analysis.md` + `{study-type}.md` at exercise time

This means existing studies are reproducible even if source templates change. Contributors modifying templates don't break past studies.

## Calibration Data

The `--calibration` flag grounds personas in real-world data instead of LLM priors.

**Single file mode:** File content is injected directly into the planning prompt.

**Directory mode:** Claude uses Glob to discover files. If `manifest.md` exists at the directory root, it's read first — it describes each file's purpose. Claude selectively reads the most relevant files. The plan output includes a "Calibration Sources" section listing what was read and extracted. Directory mode enables Glob/Grep tools for persona generation (normally Read/Write only).

Supported file types: `.md`, `.csv`, `.txt`, `.json`, `.yaml`, `.yml`.

## Claude Code Skills

Two skills in `.claude/commands/`:

**`/facet-init <config> [--name N] [--concurrency N] [--calibration path]`**
- Runs planning directly (Claude does the work inline)
- Spawns Agent per persona for generation (context isolation, same as sim.sh subprocesses)
- Wave-based: waits for each wave, builds diversity context, then spawns next wave
- Agents use `model: "sonnet"`

**`/facet-run <study-dir> <exercise-config> [--concurrency N]`**
- Spawns Agent per persona for simulation (parallel, context isolation)
- Runs analysis inline (needs to read all personas + simulations in one context)
- Agents use `model: "sonnet"`

## Key Files

```
sim.sh                  — orchestrator (init, exercise, status subcommands)
stream_filter.py        — real-time progress display, parses stream-json, uses FACET_PHASE env var
templates/
  plan.md               — planning: segments, constraint vectors, diversity matrix, name registry
  persona.md            — persona background generation (identity, psychology, domain, discovery)
  simulation.md         — per-persona exercise simulation (Chain-of-Feeling, BDI verdicts)
  analysis.md           — unified analysis → synthesis.md + artifacts.md (TWO files)
study-types/
  pricing.md            — prospect theory, mental accounting, 12-month usage tables
  copy.md               — ELM, construal level, framing effects, per-variant scoring
  features.md           — Kano model, feature interaction, prioritization caveats
  onboarding.md         — endowment/IKEA effect, psychological ownership, Fogg B=MAP
  retention.md          — hedonic adaptation, sunk cost, peak-end rule, churn taxonomy
examples/
  superhuman-product.md    — example product config (10 segments × 5 personas)
  superhuman-pricing.md    — example pricing exercise (3 tier models)
  superhuman-copy.md       — example copy exercise (6 positioning variants)
  superhuman-features.md   — example features exercise
  superhuman-onboarding.md — example onboarding exercise (3 flows)
  superhuman-retention.md  — example retention exercise (3 strategies)
research/               — ~490-source research reports informing template design
.claude/commands/
  facet-init.md         — Claude Code skill for init pipeline
  facet-run.md          — Claude Code skill for exercise pipeline
```

## Config Format

**Product config** (for `init`): Markdown with YAML frontmatter containing `segments` and `personas_per_segment`. Body describes product, key details, target market.

**Exercise config** (for `exercise`): Markdown with YAML frontmatter containing `exercise_name`, `study_type`, `options`, and optionally `copy_variants`. Body has options detail and copy variants.

See `examples/` for complete examples.

## Output Structure

```
output/{product}/
├── .templates/                     # version-locked init templates
├── plan.md                         # segment matrix, constraint vectors, diversity matrix
├── personas/
│   ├── persona-001.md              # background ONLY (identity, psychology, domain, discovery)
│   └── ...
├── .status                         # JSON-line phase completion tracking
└── exercises/
    └── {exercise-name}/
        ├── .templates/             # version-locked exercise templates
        ├── exercise.md             # copy of exercise config
        ├── simulations/
        │   ├── persona-001.md      # Chain-of-Feeling arcs, BDI verdicts, 12-month tables
        │   └── ...
        ├── synthesis.md            # analysis + recommendation + counterargument
        └── artifacts.md            # actionable deliverables + validation plan
```

## Conventions

These are invariants — do not break them:

- Personas contain ONLY backgrounds — never simulations, verdicts, or copy reactions
- Persona outlines in plan.md use `Persona #N` numbered format (sim.sh regex depends on this)
- Persona files are zero-padded: `persona-001.md`, `persona-023.md`
- Analysis produces TWO files: `synthesis.md` and `artifacts.md` (not one combined file)
- Names must be unique across the entire study (enforced by name registry in plan.md)
- All numbers in personas/simulations must be specific and internally consistent
- Template sections adapt to product domain (not hardcoded to travel/flights)
- Templates are version-locked into `.templates/` at init and exercise time
- No Bash tool in `claude` invocations — Read, Write, Glob, Grep only

## Adding a New Study Type

1. Create `study-types/{name}.md` following the pattern in existing study types
2. Include: caveat section, what it tests, simulation framework, per-persona metrics, outcome requirements
3. Create an example exercise config in `examples/` with matching `study_type` in frontmatter
4. Test: `./sim.sh init --config examples/superhuman-product.md --name test` then `./sim.sh exercise --study output/test/ --config examples/your-exercise.md`
5. Review the synthesis — does it produce actionable recommendations?

No code changes needed in sim.sh — it reads `study_type` from frontmatter and loads `study-types/{type}.md` automatically.

## Modifying Templates

1. Read the template you want to change — understand the full structure first
2. Make your change — maintain the integrity rules, quality bar, and thinking step patterns
3. Test with a full run (init + exercise) using example configs
4. Check that output format hasn't changed (downstream phases depend on it)
5. Note: your change won't affect existing studies — templates are version-locked at init/exercise time

See [CONTRIBUTING.md](CONTRIBUTING.md) for submission guidelines.
