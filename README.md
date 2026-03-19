# Facet — Pre-Launch Simulation Engine

A CLI tool that generates research-grounded narrative personas and simulates them through product exercises (pricing, copy, features). Produces synthesis with decisive recommendations, actionable artifacts, and adversarial review.

Built on the Claude CLI. No UI, no framework — just bash, prompt templates, and parallel `claude` invocations.

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│  sim.sh init                                                │
│                                                             │
│  ┌──────────┐      ┌──────────────────────────────────┐     │
│  │  PLAN    │      │  GENERATE (parallel)              │     │
│  │          │─────▶│                                    │     │
│  │ 1 claude │      │  1 claude call per persona         │     │
│  │ call     │      │  concurrency-limited               │     │
│  │          │      │  wave-based with diversity context  │     │
│  └──────────┘      └──────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘

         Personas generated ONCE, reused across exercises
                            │
                            ▼

┌─────────────────────────────────────────────────────────────┐
│  sim.sh exercise  (repeat for pricing, copy, features...)   │
│                                                             │
│  ┌──────────────────────────────┐      ┌──────────────┐     │
│  │  SIMULATE (parallel)         │      │  ANALYZE     │     │
│  │                              │─────▶│              │     │
│  │  1 claude call per persona   │      │  1 claude    │     │
│  │  reads persona + exercise    │      │  call reads  │     │
│  │  config                      │      │  everything  │     │
│  └──────────────────────────────┘      └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

### The Four Phases

**Plan** — Generates a JTBD-based segment matrix, persona constraint vectors (Big Five, behavioral economics parameters, deal-breakers), cross-reference plan with trust levels, diversity matrix, and name registry.

**Generate** — One `claude` call per persona, in parallel waves. Each persona gets fresh context with the template + plan. Produces background only (identity, psychology, domain profile, discovery). Wave-based batching feeds diversity context from completed personas into subsequent waves to prevent homogeneity.

**Simulate** — One `claude` call per persona per exercise, in parallel. Reads persona background + exercise config. Produces Chain-of-Feeling decision arcs, BDI-structured verdicts, copy reactions with specific language.

**Analyze** — Single call reads all personas + all simulations. Produces two files:
- `synthesis.md` — confidence-graded findings, behavioral mechanism analysis, stated vs. revealed preference gaps, sycophancy audit, pre-mortem, counterargument with LLM bias audit
- `artifacts.md` — actionable deliverables (pricing tables, copy recommendations, feature priorities) + validation plan

## Quick Start

```bash
# 1. Initialize: plan + generate persona backgrounds
./sim.sh init --config examples/perch-product.md --name perch

# 2. Run exercises against existing personas
./sim.sh exercise --study output/perch/ --config examples/perch-pricing.md
./sim.sh exercise --study output/perch/ --config examples/perch-copy.md
./sim.sh exercise --study output/perch/ --config examples/perch-features.md

# 3. Check status
./sim.sh status --study output/perch/
```

### Options

| Flag | Description | Default |
|------|-------------|---------|
| `--config` | Product config (init) or exercise config (exercise) | required |
| `--name` | Study name for output directory | config filename |
| `--study` | Path to existing study directory | — |
| `--concurrency` | Parallel persona generations/simulations | 5 |
| `--calibration` | Real research data to ground personas | — |

### With Calibration Data

Ground personas in real-world survey/research data instead of relying solely on LLM priors:

```bash
./sim.sh init --config examples/perch-product.md --name perch --calibration real-survey-data.md
```

## Config Format

### Product Config (for `init`)

Markdown with YAML frontmatter. The body describes the product, key details, and target market.

```yaml
---
segments: 10
personas_per_segment: 5
---

# Product: Perch

Perch is a flight price tracking and automatic rebooking service...

## Key Product Details
- Works with all major US airlines
- Handles rebooking automatically
- Domestic flights: ~35% see a price drop, average savings ~$55

## Target Market
- Frequent flyers
- Budget-conscious travelers
- Families booking multiple tickets
```

### Exercise Config (for `exercise`)

```yaml
---
exercise_name: pricing-flat-vs-commission
study_type: pricing
options:
  - name: "Model A"
    description: "$49/year flat fee — user keeps all savings"
  - name: "Model B"
    description: "Free signup, 15% commission on savings found"
copy_variants: true
---

## Options to Test

### Model A: $49/year flat fee
User pays $49/year upfront...

### Model B: Free signup, 15% commission
User signs up for free...

## Copy Variants

### Variant A: "Flat Fee, Clean"
$49/year. Every drop is yours.
```

Study types: `pricing`, `copy`, `features` (rules in `study-types/`).

## Output Structure

```
output/{product}/
├── plan.md                         # segment matrix, constraint vectors, diversity matrix
├── personas/                       # generated ONCE, reused across exercises
│   ├── persona-001.md
│   ├── persona-002.md
│   └── ...
├── .templates/                     # version-locked init templates
└── exercises/
    └── {exercise-name}/
        ├── exercise.md             # copy of exercise config
        ├── simulations/
        │   ├── persona-001.md      # Chain-of-Feeling arcs, BDI verdicts
        │   └── ...
        ├── synthesis.md            # analysis + recommendation + counterargument
        ├── artifacts.md            # actionable deliverables + validation plan
        └── .templates/             # version-locked exercise templates
```

## Research Foundation

Templates incorporate findings from ~490 academic sources across six research reports:

| Concern | Approach |
|---------|----------|
| **Anti-sycophancy** | Integrity rules at every phase. LLMs default to agreement (Sharma et al., ICLR 2024); templates explicitly permit and encourage rejection/skepticism. |
| **Behavioral economics** | Explicit parameters per persona: reference point, loss aversion, mental accounting, subscription fatigue, status quo bias. LLMs produce human-like biases only 17-57% of the time without explicit instruction. |
| **Diversity** | Constraint vectors with Big Five scores, JTBD segments, diversity matrix with 50% concentration threshold, counter-stereotypical detail quota (40%). Wave-based generation with inter-wave diversity context. |
| **Confidence calibration** | Every finding graded HIGH/MODERATE/LOW. Disclosure header on every synthesis. Known limitations per study type. |
| **Validation** | Every synthesis includes recommended real-user validation steps. |

Research reports in `research/`:
- Persona prompting techniques
- Synthetic user tools landscape
- Behavioral economics in persona simulation
- Validation and failure modes
- Persona realism research
- Simulation architecture and cognitive models

## Architecture Details

### CLI Pattern

Every phase is a `claude` CLI invocation with restricted tools:

```bash
claude --print --verbose --output-format stream-json \
  --max-turns $MAX_TURNS \
  --allowedTools "Read,Write,Glob,Grep" \
  -p "$PROMPT" 2>&1 | python3 -u stream_filter.py
```

- Tools restricted to Read, Write, Glob, Grep — no Bash (no escape hatch)
- Generation and simulation use `--model sonnet` for cost efficiency
- Analysis uses default model (Opus) for synthesis quality
- `stream_filter.py` parses `stream-json` output for real-time progress display
- Templates are version-locked into `.templates/` directories at init/exercise time

### Wave-Based Generation

Personas are generated in waves of 5. After each wave completes, summaries of generated personas are fed as diversity context into the next wave. This prevents the homogeneity that occurs when all personas are generated independently with the same prompt.

```
Wave 1: personas 1-5   (no diversity context)
Wave 2: personas 6-10  (sees summaries of 1-5)
Wave 3: personas 11-15 (sees summaries of 1-10)
...
```

## Project Structure

```
sim.sh                  # main orchestrator (init, exercise, status)
stream_filter.py        # real-time progress display for stream-json output
templates/
  plan.md               # planning phase instructions
  persona.md            # persona background generation
  simulation.md         # per-persona exercise simulation
  analysis.md           # unified analysis → synthesis.md + artifacts.md
study-types/
  pricing.md            # simulation rules for pricing exercises
  copy.md               # simulation rules for copy exercises
  features.md           # simulation rules for feature exercises
examples/
  perch-product.md      # example product config
  perch-pricing.md      # example pricing exercise
  perch-copy.md         # example copy exercise
  perch-features.md     # example features exercise
research/               # ~490-source research reports informing template design
output/                 # generated studies (gitignored)
```

## Requirements

- [Claude CLI](https://docs.anthropic.com/en/docs/claude-cli) (`claude` command available)
- Python 3 (for `stream_filter.py`)
- Bash
