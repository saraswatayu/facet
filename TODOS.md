# TODOS

## P2: Automated Diversity Metrics

**What:** Add a Python script (`diversity_check.py`) that computes pairwise embedding similarity between persona files and flags pairs above 0.90 cosine similarity threshold. Also compute MTLD lexical diversity scores across the persona set.

**Why:** LLM-generated personas have 30-50% less variance than real humans (Bisbee et al., 2024). The current diversity matrix in plan.md is a visual check — automated metrics would catch subtle homogeneity that visual inspection misses.

**Pros:** Mechanical enforcement of diversity. Data-driven quality improvement over time.
**Cons:** Adds Python dependency. Requires embedding API or local model for similarity. Adds complexity to a clean shell pipeline.
**Effort:** M (human) → S (CC)
**Depends on:** Requires deciding on embedding provider (OpenAI, local model, or Claude embedding).

## ~~P2: Batched Generation~~ DONE

Implemented: wave-based generation in sim.sh. Waves of 5, inter-wave summaries passed as diversity context. See commit history.

## P3: Retrospective Validation Corpus

**What:** Build a set of known outcomes (past A/B tests, pricing experiments, market data) and verify Facet can retrodict them. If the simulation can't predict known results, it shouldn't be trusted for novel decisions.

**Why:** Currently there is no empirical validation that Facet's outputs match reality. The Stanford 1,000-person study achieved 85% accuracy, but that required 2-hour interviews per person. Facet's demographic-only approach will perform below that threshold.

**Pros:** Empirical confidence in the tool. Can identify which study types are most/least reliable.
**Cons:** Requires finding products with known A/B test results willing to share data.
**Effort:** L (human) → L (CC)
**Depends on:** Access to real outcome data.

## ~~P3: Multi-Persona Thinking for Plan Phase~~ DONE

Implemented: section 0 "Perspective Brainstorm" in plan.md. 6 radically different perspectives brainstormed before segment design. See commit history.

## P2: npm/CLI Package

**What:** Wrap Facet in an installable CLI package (`npx facet init` or `pip install facet-sim`) for platform-independent distribution.

**Why:** Reaches users outside the Claude Code ecosystem. Standard package manager discoverability, semver, auto-updates.

**Pros:** Familiar install story for all developers. Version management. Broadest possible reach.
**Cons:** Adds npm or pip packaging infrastructure. Wrapping bash in npm/pip is awkward. Maintenance burden of a second distribution channel.
**Context:** Identified during CEO + eng review (2026-03-19). The repo's self-contained directory structure (templates, study-types, examples alongside sim.sh) maps cleanly to an npm or pip package. Post-1.0 — needs user traction first.
**Effort:** L (human) → M (CC)
**Depends on:** Having external users. Reaching v1.0 stability.

## P3: Skills Migration & Plugin Distribution

**What:** Convert to gstack-pattern skill directories at repo root (facet-init/SKILL.md, facet-run/SKILL.md, etc.) for Claude Code plugin distribution. Install via `git clone <repo> ~/.claude/skills/facet/`.

**Why:** One-command install for Claude Code users. Slash command UX (`/facet-init`) instead of terminal commands. Positions for marketplace distribution.

**Pros:** Ecosystem discoverability. Slash command UX. Proven pattern (gstack, 27k stars).
**Cons:** Second interface to maintain alongside sim.sh. Premature for 0-user pre-1.0 tool.
**Context:** Full architecture resolved in CEO + eng review (2026-03-19). Gstack pattern chosen: skill dirs at repo root, `../templates/` paths via `$CLAUDE_SKILL_DIR`, no plugin.json needed. 6 skills planned: init, run, status, validate, upgrade, help. CEO plan at `~/.gstack/projects/saraswatayu-facet/ceo-plans/2026-03-19-plugin-distribution.md`.
**Effort:** M (human) → S (CC: ~1 hour)
**Depends on:** Having external users who want Claude Code integration.

## P3: Plugin Marketplace Listing

**What:** Submit Facet to a Claude Code plugin marketplace (official or community) for one-command `/plugin install facet` access and auto-updates.

**Why:** Maximum discoverability for Claude Code users. Auto-updates. One-command install without git clone.

**Pros:** Frictionless install. Auto-updates. Namespace protection.
**Cons:** Marketplace system maturity uncertain. Requires maintaining a listing.
**Context:** Requires skills migration (P3 above) first. Marketplace conventions observed in review: Anthropic uses `commands/`, community uses `skills/SKILL.md`, gstack uses neither. Wait for ecosystem to stabilize.
**Effort:** S (human) → S (CC)
**Depends on:** Skills migration. User adoption signal.
