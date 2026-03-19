# TODOS

## P2: Automated Diversity Metrics

**What:** Add a Python script (`diversity_check.py`) that computes pairwise embedding similarity between persona files and flags pairs above 0.90 cosine similarity threshold. Also compute MTLD lexical diversity scores across the persona set.

**Why:** LLM-generated personas have 30-50% less variance than real humans (Bisbee et al., 2024). The current diversity matrix in plan.md is a visual check — automated metrics would catch subtle homogeneity that visual inspection misses.

**Pros:** Mechanical enforcement of diversity. Data-driven quality improvement over time.
**Cons:** Adds Python dependency. Requires embedding API or local model for similarity. Adds complexity to a clean shell pipeline.
**Effort:** M (human) → S (CC)
**Depends on:** Requires deciding on embedding provider (OpenAI, local model, or Claude embedding).

## P2: Batched Generation

**What:** Generate personas in waves of 5-10 rather than all independently. Each wave includes summaries of previously generated personas to encourage distinctiveness.

**Why:** Even with good constraint vectors, parallel generation can produce homogeneous outputs because each Claude call has no awareness of what other calls produced. Guide-to-Generation (G2) research shows coordinated generation with a Diversity Guide prevents convergence.

**Pros:** 1.6-2.1x diversity improvement on top of structural constraints.
**Cons:** Significantly more complex orchestrator logic. Slower generation. Wave coordination adds failure modes.
**Effort:** L (human) → M (CC)
**Depends on:** Should evaluate diversity metrics first to determine if structural constraints are sufficient.

## P3: Retrospective Validation Corpus

**What:** Build a set of known outcomes (past A/B tests, pricing experiments, market data) and verify Facet can retrodict them. If the simulation can't predict known results, it shouldn't be trusted for novel decisions.

**Why:** Currently there is no empirical validation that Facet's outputs match reality. The Stanford 1,000-person study achieved 85% accuracy, but that required 2-hour interviews per person. Facet's demographic-only approach will perform below that threshold.

**Pros:** Empirical confidence in the tool. Can identify which study types are most/least reliable.
**Cons:** Requires finding products with known A/B test results willing to share data.
**Effort:** L (human) → L (CC)
**Depends on:** Access to real outcome data.

## P3: Multi-Persona Thinking for Plan Phase

**What:** Before designing segments, have the plan phase brainstorm 5-6 very different perspectives on the product (a skeptic, an enthusiast, a confused newcomer, a budget parent, a tech early adopter, an elderly technophobe). Then use these perspectives to inform segment design.

**Why:** Multi-Persona Thinking (MPT) reduces bias in LLM outputs by engaging the model in dialectical process across different social identities (arXiv:2601.15488).

**Pros:** Reduces stereotypical segment designs. Low cost — just a prompt addition.
**Cons:** Adds ~500 tokens to plan phase. May slow plan generation.
**Effort:** S (human) → S (CC)
**Depends on:** None. Can be added independently.
