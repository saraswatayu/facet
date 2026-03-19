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

## Install

```bash
git clone https://github.com/saraswatayu/facet.git
cd facet
./setup
```

## Quick Start

```bash
# 1. Initialize: plan + generate persona backgrounds
./sim.sh init --config examples/superhuman-product.md --name superhuman

# 2. Run exercises against existing personas
./sim.sh exercise --study output/superhuman/ --config examples/superhuman-pricing.md
./sim.sh exercise --study output/superhuman/ --config examples/superhuman-copy.md
./sim.sh exercise --study output/superhuman/ --config examples/superhuman-features.md

# 3. Check status
./sim.sh status --study output/superhuman/
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
./sim.sh init --config examples/superhuman-product.md --name superhuman --calibration real-survey-data.md
```

## Config Format

### Product Config (for `init`)

Markdown with YAML frontmatter. The body describes the product, key details, and target market.

```yaml
---
segments: 10
personas_per_segment: 5
---

# Product: Superhuman

Superhuman is a premium email client built for speed...

## Key Product Details
- $30/month per user, works with Gmail and Outlook
- AI features: summarize threads, draft replies, auto-triage
- Keyboard-first design, every interaction under 100ms

## Target Market
- Startup founders and CEOs
- Sales professionals
- Venture capitalists and investors
```

### Exercise Config (for `exercise`)

```yaml
---
exercise_name: pricing-tiers
study_type: pricing
options:
  - name: "Model A"
    description: "$30/month flat — current pricing, no free tier"
  - name: "Model B"
    description: "Free tier + $30/month Pro — freemium with AI features gated"
  - name: "Model C"
    description: "$15/month Starter + $30/month Pro — two paid tiers"
copy_variants: true
---

## Options to Test

### Model A: $30/month flat (status quo)
One plan, one price, every feature...

### Model B: Free tier + $30/month Pro
Free tier with core speed. AI features gated behind $30/month...

## Copy Variants

### Variant A: "Premium, Unapologetic"
$30/month. The fastest email experience ever made.
```

Study types: `pricing`, `copy`, `features`, `onboarding`, `retention` (rules in `study-types/`).

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
  superhuman-product.md    # example product config
  superhuman-pricing.md    # example pricing exercise
  superhuman-copy.md       # example copy exercise
  superhuman-features.md   # example features exercise
  superhuman-onboarding.md # example onboarding exercise
  superhuman-retention.md  # example retention exercise
research/               # ~490-source research reports informing template design
output/                 # generated studies (gitignored)
```

## What This Is (and Isn't)

Facet generates hypotheses, not evidence. The output looks like a $50K research engagement — rich narratives, specific numbers, emotional arcs — but it's all generated by an LLM that has never met a real user. Treat every finding as a starting point for real research, not a conclusion.

**Good for:** Directional insights, hypothesis generation, rapid screening of pricing/copy variants, identifying segments and concerns worth investigating, preparing better interview guides for real users.

**Not good for:** Final pricing decisions, go/no-go launch calls, feature prioritization (LLMs care about everything equally), non-Western or underrepresented populations, novel product categories with no training data analogues.

### How Facet compares to the landscape

The synthetic research space ranges from $100M-funded startups (Simile, Aaru) with real behavioral data and fine-tuned models, to enterprise platforms (Qualtrics Edge, Ditto) with census-calibrated panels, to open-source tools (TinyTroupe, PolyPersona) with basic prompting.

Facet is different in two ways:

1. **Transparent methodology.** Every commercial tool is a black box. Facet's templates are readable prompts — you can audit exactly why a persona said what it said. No other tool in this space offers this.

2. **Research-grounded anti-bias design.** Templates encode specific countermeasures for documented LLM failure modes: anti-sycophancy rules (because RLHF causes agreement bias), explicit behavioral economics parameters (because LLMs only produce human-like biases 17-57% of the time without instruction), diversity enforcement (because LLMs homogenize by default), and adversarial review (because no one else builds skepticism into the pipeline).

Facet is *not* different in that it's still prompt engineering on a general-purpose LLM. It can't compete on raw accuracy with tools trained on millions of real survey responses. The research hierarchy is clear: interview-based (~85% accuracy) > fine-tuned on survey data (~78-88%) > census-calibrated (~75-92%) > rich prompting (Facet, ~70-75%) > naive LLM query (~63%).

### Known limitations

- **Illusion of depth.** Specific details ("$38,500/year, $18.50/hour") are plausible fiction, not data. The richer the output, the easier it is to forget this.
- **Can't know what it can't know.** Real users have DIY workarounds, half-formed habits, and context no LLM can simulate. Facet operates from "what should be" rather than "what is."
- **Config bias.** If your exercise config describes Option A more favorably than Option B, the entire simulation leans toward A.
- **Run-to-run variance.** Identical parameters can produce different results. Facet runs once — no multi-run consistency check.
- **WEIRD bias.** LLMs are overtrained on English-language, Western, educated, middle-class perspectives. Results for other populations should be treated with extra caution.
- **Feature prioritization is the weakest use case.** Synthetic personas tend to care about everything equally (NN/g, 2024). Use the features study type for surfacing reactions and concerns, not for producing ranked priority lists.

## Requirements

- [Claude CLI](https://docs.anthropic.com/en/docs/claude-cli) (`claude` command available)
- Python 3 (for `stream_filter.py`)
- Bash

Run `./setup` to verify all dependencies.
