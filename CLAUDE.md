# Facet — Pre-Launch Simulation Engine

A CLI tool that generates detailed narrative personas and simulates them through product decisions (pricing, copy, features). Produces synthesis with decisive recommendations and actionable artifacts.

## Architecture

6-phase pipeline, each phase is a `claude` CLI invocation:

```
Config → Plan → Generate (parallel) → Weave → Synthesize → Artifacts → Adversarial
```

- **Plan**: Generates segment matrix, persona outlines, name registry, simulation parameters
- **Generate**: One `claude` call per persona, parallel (configurable concurrency). Each persona gets fresh context with the template + plan
- **Weave**: Single call reads all personas, adds cross-references and referral chains
- **Synthesize**: Single call reads all personas, produces segment-level analysis and recommendation
- **Artifacts**: Single call generates usable output (copy, FAQ, CTA, segment angles)
- **Adversarial**: Fresh context argues against the synthesis recommendation

## Key Files

- `sim.sh` — Main orchestrator. Subcommands: `run`, `plan`, `generate`, `synthesize`, `status`
- `stream_filter.py` — Parses `--output-format stream-json` for real-time progress display
- `templates/` — Prompt templates for each phase
- `study-types/` — Simulation rules per study type (pricing, copy, features)
- `examples/` — Example study configs
- `output/` — Generated studies (gitignored)

## Config Format

Markdown with YAML frontmatter. Frontmatter has structured params (study_type, segments, personas_per_segment, options). Markdown body has product description, target market, options detail, optional copy variants.

## CLI Pattern

```bash
claude --print --verbose --output-format stream-json \
  --max-turns $MAX_TURNS \
  --allowedTools "Read,Write,Glob,Grep" \
  -p "$PROMPT" 2>&1 | python3 -u stream_filter.py
```

Tools restricted to Read, Write, Glob, Grep. No Bash (no escape hatch). Max-turns generous per phase: Plan 20, Generate 15, Weave 75, Synthesize 50, Artifacts 20, Adversarial 20.

## Conventions

- Personas are markdown files in `output/{study}/personas/`
- All numbers in personas must be specific and internally consistent
- Names must be unique across the entire study (enforced by plan.md name registry)
- Template sections adapt to product domain (not hardcoded to travel/flights)
