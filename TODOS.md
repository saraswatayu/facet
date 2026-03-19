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
