# Contributing to Facet

Thanks for your interest in contributing. Facet is a pre-1.0 project — contributions of all sizes are welcome.

Read [README.md](README.md) for what Facet does. Read [CLAUDE.md](CLAUDE.md) for how the codebase works. Big architectural changes should start as an issue first.

## Ways to Contribute

### Template Improvements

Templates in `templates/` are the heart of Facet. They encode research-grounded prompt engineering for persona generation, simulation, and analysis.

**Before changing a template:**
- Read the template you want to modify — they're detailed markdown files
- Check `research/` for existing findings that might inform your change
- Understand that templates follow consistent patterns: integrity rules, quality bar, thinking steps (brainstorm sections not included in output), consistency self-check

**What makes a good template change:**
- Grounded in research (cite a paper or finding)
- Addresses a specific failure mode (sycophancy, homogeneity, stereotyping, etc.)
- Tested against example configs — run a full init + exercise and compare output quality

**What to know:**
- Templates are version-locked into `.templates/` directories at init/exercise time. Existing studies keep their original templates even after you change the source.
- Analysis produces TWO files (synthesis.md + artifacts.md) — don't merge them into one.
- Persona outlines in plan.md use `Persona #N` format — sim.sh regex depends on this.

### New Study Types

Add new exercise types (beyond pricing, copy, features) by creating `study-types/X.md`.

**Required sections** (follow existing patterns in `study-types/`):
- Important caveat (what this study type can and can't do)
- What this study tests
- Simulation framework (which behavioral economics principles apply)
- Per-persona metrics and outcome structure
- Outcome requirements (e.g., "at least 1 persona should reject all options")

**Also needed:**
- An example exercise config in `examples/`
- Test the full pipeline: `./sim.sh init` → `./sim.sh exercise` → check synthesis quality

### Code Changes

`sim.sh` (~670 lines of bash) and `stream_filter.py` (~120 lines of Python) are the orchestration layer.

- sim.sh uses `set -euo pipefail` — keep it that way
- No new dependencies beyond bash, Python 3 stdlib, and Claude CLI
- Test with: `./sim.sh init --config examples/superhuman-product.md --name test`
- Claude Code skills in `.claude/commands/` follow the same patterns — Agent tool for isolation, Sonnet for generation/simulation

### Research Additions

The `research/` directory contains reports synthesizing ~490 academic sources. To add new research:

- Cite specific papers with author, year, URL, and key finding
- Explain how the finding should influence template design
- If it suggests a template change, include that change in the same PR

## Development Setup

1. Clone the repo
2. Verify dependencies: `claude --version`, `python3 --version`, `bash --version`
3. Run an example study:
   ```bash
   ./sim.sh init --config examples/superhuman-product.md --name test
   ./sim.sh exercise --study output/test/ --config examples/superhuman-pricing.md
   ```
4. Check output in `output/test/`

### Using Claude Code

Facet includes two Claude Code slash commands for interactive testing:
- `/facet-init` — runs the full init pipeline inside Claude Code
- `/facet-run` — runs an exercise pipeline inside Claude Code

These are useful for testing template changes interactively without running sim.sh.

## Submitting Changes

1. Fork and create a branch
2. Make your changes
3. Test with the example configs
4. Submit a PR — the template will guide you through what to include

## Style

- **Commits**: imperative, lowercase, no period — match existing history (`sim.sh: wave-based batched generation with inter-wave diversity context`)
- **Templates**: markdown, no HTML, consistent section headers
- **Code**: bash with `set -euo pipefail`, Python 3 standard library only
- **Personas/simulations**: all numbers specific and internally consistent, no vague language
