# Facet Improvement Plan

Synthesized from ~490 sources across 6 research reports. Every recommendation has citations back to the research. Organized by pipeline phase, then by impact level.

Items marked ✅ have been implemented. Items marked 🔲 are open.

---

## 1. PIPELINE ARCHITECTURE

### ✅ 1.1 Wave-Based Batched Generation

Generate personas in waves of 5 with diversity context passed between waves. Implemented in sim.sh `run_generate()`.

**Research:** Guide-to-Generation (G2) shows coordinated generation with a Diversity Guide prevents convergence (arXiv:2511.00432). Persona Generators (2026) formalize this as quasi-random sampling along orthogonal diversity axes.

### ✅ 1.2 Mandatory Disclosure Header

Every synthesis includes confidence grades, disclosure of synthetic methodology, and known limitations per study type.

**Research:** Industry consensus (NN/g, ESOMAR, MRS Delphi). "The Synthetic Persona Fallacy" (ACM Interactions, 2026) argues presenting synthetic research as user research is a "quiet crisis in research integrity."

### ✅ 1.3 Template Version Locking

Templates copied into `.templates/` directories at init and exercise time. Existing studies are reproducible even if source templates change.

**Research:** Prompt sensitivity research shows even minor rewording can shift results by up to 76 accuracy points (arXiv:2310.11324).

### 🔲 1.4 Add a Validation Phase (Between Generate and Simulate)

**What:** A lightweight quality-gate that reads all generated personas and checks for: sycophancy (too many positive verdicts), homogeneity (embedding similarity between personas), numerical implausibility, and internal contradictions.

**Why:** LLM personas have 30-50% less variance than real humans (Bisbee et al., 2024). Sycophancy is the single most dangerous failure mode (Sharma et al., ICLR 2024). Without a quality gate, these problems propagate into synthesis.

**How:** Single Claude call reads all persona files, outputs a validation report with pass/fail per persona plus overall diversity score. Failed personas get flagged for regeneration.

### 🔲 1.5 Split-Half Reliability

**What:** Run the full study twice. Compare whether both halves reach the same directional conclusion.

**Why:** Bisbee et al. found replicating silicon sampling results months later using identical prompts was "impossible." Up to 10% variation observed even under deterministic settings (Schmalbach, 2024). Chain-of-Thought actually *amplifies* instability in value-laden contexts.

**How:** `sim.sh exercise` gets a `--reliability` flag that runs the study twice and compares synthesis recommendations.

### 🔲 1.6 Config Neutrality Check

**What:** Before running, check that options in the exercise config are described with equal detail and neutral framing. Warn if one option has 3x more description than another.

**Why:** Confirmation bias research (arXiv:2504.09343) shows AI models mirror the language and assumptions in prompts. If the config describes Option A more favorably, all downstream outputs reflect that bias.

---

## 2. PLAN TEMPLATE (templates/plan.md)

### ✅ 2.1 JTBD-Based Segments

Segments structured around jobs-to-be-done, not just demographics.

**Research:** Demographics alone explain only ~1.5% of variance in response similarity (SCOPE framework, arXiv:2601.07110). Values and sociopsychological factors are far more predictive.

### ✅ 2.2 Behavioral Economics Parameters Per Segment

Plan specifies per-segment: adoption curve position, loss aversion intensity, subscription fatigue level, processing mode, status quo bias strength.

**Research:** LLMs are bias-consistent in only 17.8-57.3% of instances (arXiv:2509.22856). Without explicit instructions, they won't reliably produce human-like decision biases.

### ✅ 2.3 Diversity Matrix with Anti-Clustering Constraints

Plan includes a diversity matrix showing each persona's position on key axes (income, age, tech comfort, risk tolerance, decision style, adoption stage) with 50% concentration threshold.

**Research:** Naive prompting leads to mode collapse — simply asking for "diverse" personas produces populations clustered around stereotypical responses (Persona Generators, 2025). Structural constraints are the only reliable mitigation.

### ✅ 2.4 Constraint Vectors Per Persona

Each persona outline includes structured attributes: Big Five scores, decision style, adoption stage, subscription count, status quo bias, reference product, discovery channel.

**Research:** The Personality Trap (2026) found that more creative freedom in persona generation produces more biased, less representative results. Structured constraints are more effective than narrative descriptions (SCOPE framework).

### ✅ 2.5 Multi-Persona Thinking Step

Plan template includes a "Perspective Brainstorm" step where 6 radically different perspectives are brainstormed before segment design.

### 🔲 2.6 Latin Hypercube Sampling

**What:** Formally enforce that persona outlines collectively cover the full range of each diversity axis without redundant combinations.

**Why:** LHS efficiently explores high-dimensional parameter spaces by ensuring every interval of every parameter is sampled exactly once. Nearly Orthogonal Latin Hypercubes can analyze 22 variables in as few as 129 runs (Viana, 2016).

### 🔲 2.7 Information Access Specification Per Persona

**What:** Specify per persona what they actually see/know: "Saw only the homepage hero and pricing table" vs. "Got a verbal description from a friend (partially accurate)."

**Why:** SimToM (Theory of Mind) research shows explicitly modeling what each persona knows and doesn't know produces more realistic behavior. Real users discover products through very different information paths.

### 🔲 2.8 Census-Grounded Names

**What:** Names should reflect realistic demographic distributions. Not all names should be unusual or distinctive — some should be common.

**Why:** DeepPersona and PersonaGen research shows census-grounded names improve realism. LLMs default to generating distinctive/interesting names.

---

## 3. PERSONA TEMPLATE (templates/persona.md)

### ✅ 3.1 Anti-Sycophancy Instruction Block

"Simulation Integrity Rules" at the top of every persona template. Explicit permission to reject, be skeptical, or be indifferent.

**Research:** RLHF trains models to agree (Sharma et al., ICLR 2024). MIT found personalization features *increase* agreeableness (2026). Explicit rejection permission improved critical assessment in medical contexts (npj Digital Medicine, 2025).

### ✅ 3.2 Behavioral Economics Profile Section

Each persona includes: reference point, loss aversion, mental account, subscription fatigue, status quo bias, time preference, decision style, processing mode.

**Research:** LLMs don't reliably produce human behavioral biases without explicit instruction (17.8-57.3% consistency per arXiv:2509.22856). Prospect theory doesn't directly apply to LLMs (Yaron et al., 2025).

### ✅ 3.3 Verbalized Sampling (Pre-Generation Brainstorm)

Before writing, brainstorm 3 distinct archetypes (enthusiastic, skeptical, surprising), then develop the one matching the constraint vector.

**Research:** Verbalized Sampling increases diversity by 1.6-2.1x over direct prompting (arXiv:2510.01171). Training-free, model-agnostic, works at any temperature.

### ✅ 3.4 Consistency Self-Check

End of template verifies: income vs. spending, NPS vs. emotional reactions, referral behavior vs. personality, dates and amounts add up.

**Research:** Self-Refine (Madaan et al., 2023) shows ~20% improvement from self-critique. LLMs exhibit 17.7% self-contradiction rate (Mun et al., 2023).

### ✅ 3.5 Contrastive Quality Examples

4+ specific vs. generic paired examples ("$38,500/year" not "moderate salary").

**Research:** Contrastive examples outperform standard few-shot prompting in both performance and token efficiency (arXiv:2403.08211). Near-miss negatives are more influential than obviously incorrect ones (arXiv:2602.03516).

### ✅ 3.6 Chain-of-Feeling Scaffolding

Internal monologues structured as: gut reaction → building considerations → moment of doubt → resolution.

**Research:** MIRROR framework (2025) shows parallel cognitive and emotional threads produce more authentic reasoning.

### ✅ 3.7 Anti-Homogenization Instructions

Explicit instructions to vary vocabulary, sentence complexity, and internal monologue style. Anti-patterns listed (present participle overuse, balanced constructions).

**Research:** PNAS (2025) found instruction-tuned models use present participle clauses at 2-5x human rates. The homogenizing effect is well-documented (Cell, Trends in Cognitive Sciences, 2026).

### ✅ 3.8 Deal-Breakers Field

Each persona has specific conditions under which they reject ALL options regardless.

**Research:** Real users have absolute deal-breakers. Synthetic users "seem to care about everything" (NN/g). Explicit deal-breakers force realistic rejection.

### 🔲 3.9 XML Tag Restructuring

**What:** Wrap prompt sections in XML tags. Place persona assignment first (primacy), output template last (recency).

**Why:** "Lost in the Middle" (Liu et al., TACL 2024) shows 30%+ performance degradation for information in the middle of long contexts. Anthropic recommends XML tags to structure prompts.

---

## 4. SIMULATION TEMPLATE (templates/simulation.md)

### ✅ 4.1 Chain-of-Feeling Decision Arcs

Every option simulation follows: gut reaction → building considerations → moment of doubt → resolution.

### ✅ 4.2 BDI-Structured Verdicts

Beliefs, Desires, and Intentions explicitly stated per option.

### ✅ 4.3 Integrity Rules

Rejection is valid. Deal-breakers must be honored. NPS > 8 requires exceptional justification. Not every persona is a customer.

---

## 5. ANALYSIS TEMPLATE (templates/analysis.md)

### ✅ 5.1 Confidence Grading

Every finding graded HIGH/MODERATE/LOW with reasoning.

### ✅ 5.2 Behavioral Mechanism Analysis

Findings explain which behavioral economics mechanisms drove the result, not just outcomes.

### ✅ 5.3 Sycophancy Audit

Synthesis checks for: excessive positivity (>70%), variance compression, missing negatives, demographic stereotyping.

### ✅ 5.4 Pre-Mortem

Specific failure narrative: what went wrong, which assumption proved false, which segment behaved differently.

### ✅ 5.5 Alternative Recommendation (Counterargument)

Adversarial must propose a specific alternative strategy, not just critique.

### ✅ 5.6 LLM Bias Audit

Check for sycophancy, variance compression, stereotyping, WEIRD bias, inconsistent behavioral biases.

### ✅ 5.7 Validation Plan Artifact

Each key finding mapped to: what to test, with whom, how, what would confirm/invalidate, priority.

### ✅ 5.8 Report Splits, Don't Average

When personas disagree within a segment, report the split ratio and identify the differentiating factor.

---

## 6. STUDY TYPE RULES

### ✅ 6.1 Pricing (study-types/pricing.md)

Includes: subscription fatigue, zero price effect, flat-rate bias, charm pricing, decoy/compromise effect, payment coupling, loss aversion, anchoring. Framed as directional, not precise WTP.

### ✅ 6.2 Copy (study-types/copy.md)

Includes: ELM (central/peripheral processing), construal level, reactance, framing effects, pairwise comparison ranking.

### ✅ 6.3 Features (study-types/features.md)

Includes: Kano model categorization, feature interaction analysis, forced ranking with explicit caveat that it's the weakest study type.

### ✅ 6.4 Onboarding (study-types/onboarding.md)

Includes: endowment effect, IKEA effect, psychological ownership, status quo bias, default effect, Fogg B=MAP, trial dynamics.

### ✅ 6.5 Retention (study-types/retention.md)

Includes: hedonic adaptation, sunk cost, peak-end rule, post-purchase rationalization, trust decay, churn taxonomy.

---

## 7. ORCHESTRATOR (sim.sh)

### ✅ 7.1 Wave-Based Generation with Diversity Context

Waves of 5. `extract_persona_summary()` builds summaries. Inter-wave diversity injection.

### ✅ 7.2 Template Version Locking

Templates copied to `.templates/` at init and exercise time.

### ✅ 7.3 Calibration Data Support

Single file or directory mode. Directory mode enables Glob/Grep, uses manifest.md for discovery.

### ✅ 7.4 Post-Generation Validation Summary

Checks for deal-breaker presence (≥25% threshold) and behavioral economics profile presence. Warns on >20% generation failure rate.

### 🔲 7.5 Full Persona Validation Phase

**What:** Dedicated Claude call that reads ALL personas and checks for sycophancy rate, pairwise similarity, numerical plausibility, and internal contradictions.

**How:** New phase between generate and simulate. Outputs validation report. Failed personas flagged for regeneration.

### 🔲 7.6 Automated Diversity Metrics

**What:** Python script computing pairwise embedding similarity and MTLD lexical diversity across persona set.

**Why:** LLM personas have 30-50% less variance than real humans (Bisbee et al., 2024). Current diversity matrix is a visual check — automated metrics catch subtle homogeneity.

**Trade-off:** Adds Python dependency and requires embedding API or local model.

---

## 8. CROSS-CUTTING

### ✅ 8.1 Positioning

Facet explicitly positioned as hypothesis generation, not user research replacement. README includes "What This Is (and Isn't)" section with accuracy hierarchy and known limitations.

### ✅ 8.2 Open Source

MIT licensed. CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md, GitHub templates. Research reports included.

---

## Open Items Summary

| # | Item | Impact | Effort |
|---|------|--------|--------|
| 1.4 | Validation phase (quality gate between generate and simulate) | High | Medium |
| 1.5 | Split-half reliability (run twice, compare) | High | Medium |
| 1.6 | Config neutrality check (warn on biased framing) | Medium | Small |
| 2.6 | Latin Hypercube Sampling for persona attributes | Medium | Medium |
| 2.7 | Information access specification per persona | Medium | Small |
| 2.8 | Census-grounded name distributions | Low | Small |
| 3.9 | XML tag restructuring of prompts | Medium | Medium |
| 7.5 | Full persona validation phase in orchestrator | High | Medium |
| 7.6 | Automated diversity metrics (embedding similarity) | Medium | Large |

---

## Sources Referenced

This plan synthesizes findings from 6 research reports totaling ~490 sources. Key citations:

- Anti-sycophancy: Sharma et al. ICLR 2024; MIT 2026; Northeastern 2026; npj Digital Medicine 2025
- Behavioral economics encoding: Bini et al. NBER 2025; Yaron et al. 2025; arXiv:2509.22856
- Verbalized Sampling: arXiv:2510.01171
- XML tags / Lost in the Middle: Anthropic docs; Liu et al. TACL 2024
- Contrastive examples: arXiv:2403.08211; arXiv:2602.03516
- Consistency self-check: Madaan et al. 2023; Mun et al. 2023
- JTBD segments: NN/g; SCOPE framework arXiv:2601.07110
- Latin Hypercube: Viana 2016; Persona Generators 2026
- Personality Trap structured constraints: arXiv:2602.03334
- Subscription fatigue: Self Financial 2025; CivicScience 2024-2025
- WOM distortion: PMC 2023
- Pre-mortem: Veinott ISCRAM 2010
- Confidence grading: Huang et al. 2025; Columbia mega-study
- Feature study limitation: NN/g
- Kano model: Kano et al. 1984
- Split-half reliability: Bisbee et al. 2024
- Endowment/IKEA effect: Norton, Mochon & Ariely 2012; Kahneman, Knetsch & Thaler 1990
- Hedonic adaptation: Brickman & Campbell 1971
- Sunk cost: Arkes & Blumer 1985
- Peak-end rule: Kahneman et al. 1993
- Commercial landscape: Simile, Aaru, Ditto, Evidenza, Qualtrics, Synthetic Users, 16 tools analyzed
