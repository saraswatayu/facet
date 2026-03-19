# Facet Improvement Plan

Synthesized from ~490 sources across 6 research reports. Every recommendation has citations back to the research. Organized by pipeline phase, then by impact level.

---

## 1. PIPELINE ARCHITECTURE

### 1.1 Add a Validation Phase (New Phase: Between Generate and Weave)

**What:** A lightweight quality-gate that reads all generated personas and checks for: sycophancy (too many positive verdicts), homogeneity (embedding similarity between personas), numerical implausibility, and internal contradictions.

**Why:** LLM personas have 30-50% less variance than real humans (Bisbee et al., 2024). Sycophancy is the single most dangerous failure mode (Sharma et al., ICLR 2024). Without a quality gate, these problems propagate into synthesis and produce unreliable recommendations.

**How:** Single Claude call reads all persona files, outputs a validation report with pass/fail per persona plus overall diversity score. Failed personas get flagged for regeneration.

### 1.2 Add Split-Half Reliability (Orchestrator Enhancement)

**What:** Run the full study twice with different random seeds. Compare whether both halves reach the same directional conclusion.

**Why:** Bisbee et al. found that replicating silicon sampling results months later using identical prompts was "impossible." Up to 10% variation in output observed even under deterministic settings (Schmalbach, 2024). Chain-of-Thought actually *amplifies* instability in value-laden contexts.

**How:** `sim.sh run` gets a `--reliability` flag that runs the study twice and compares synthesis recommendations. Report only findings consistent across both runs.

### 1.3 Consider Batched Generation (Instead of Fully Parallel)

**What:** Generate personas in small batches of 5-10 rather than all independently. Each batch receives summaries of already-generated personas.

**Why:** Guide-to-Generation (G2) research shows that coordinated generation with a Diversity Guide prevents convergence (arXiv:2511.00432). Persona Generators (2026) formalize this as quasi-random sampling along orthogonal diversity axes followed by expansion.

**How:** Modify `run_generate()` to process in waves. Wave 1: first 5 personas. Wave 2: next 5 with Wave 1 summaries in context. Slower but more diverse.

### 1.4 Add Mandatory Disclosure Header

**What:** Every output file (synthesis, artifacts, counterargument) starts with: "This study was conducted using AI-simulated personas. Results represent directional hypotheses, not validated user research."

**Why:** Industry consensus (NN/g, ESOMAR, MRS Delphi) and ethical requirements. The "Synthetic Persona Fallacy" (ACM Interactions, 2026) argues that presenting synthetic research as user research is a "quiet crisis in research integrity."

---

## 2. PLAN TEMPLATE (templates/plan.md)

This is the highest-leverage improvement target. The plan determines everything downstream.

### 2.1 HIGH IMPACT

#### 2.1.1 Restructure Segments Around Jobs-to-be-Done

**Current:** Segments are demographic/psychographic ("Budget-Conscious Single Parents").

**Proposed:** Segments start with the *job* the product does for them, then add demographic variation within each job-based segment.

**Why:** NN/g and JTBD research show that customers who share similar jobs often have different demographics. Demographics alone explain only ~1.5% of variance in response similarity (SCOPE framework, arXiv:2601.07110). Values and sociopsychological factors are far more predictive.

**Example change:**
```
Current: "Budget-Conscious Single Parents"
Proposed: "Replacing a Manual Workaround" — People currently solving this problem with DIY methods, spreadsheets, or competitor tools. Diverse ages, incomes, and tech comfort.
```

#### 2.1.2 Add Behavioral Economics Parameters Per Segment

**Current:** Segments have demographic traits, psychographic traits, expected behavior.

**Proposed:** Add per-segment:
- Adoption curve position (innovator/early adopter/early majority/late majority/laggard)
- Expected loss aversion intensity (low/medium/high)
- Subscription fatigue level (existing subscription count range)
- Primary influence principle (which of Cialdini's 7 resonates)
- Processing mode (System 1 intuitive / System 2 analytical)
- Status quo bias strength (weak/moderate/strong)

**Why:** LLMs are bias-consistent in only 17.8-57.3% of instances (arXiv:2509.22856). Without explicit instructions, they won't reliably produce human-like decision biases. The behavioral economics research is unambiguous: these must be specified, not left to chance.

#### 2.1.3 Apply Latin Hypercube Sampling to Persona Attributes

**Current:** Plan asks for diversity but doesn't enforce coverage of the attribute space.

**Proposed:** Define orthogonal diversity axes (income, age, tech comfort, risk tolerance, decision speed, subscription count, adoption stage) and require that persona outlines collectively cover the full range of each axis without redundant combinations.

**Why:** LHS efficiently explores high-dimensional parameter spaces by ensuring every interval of every parameter is sampled exactly once. Nearly Orthogonal Latin Hypercubes can analyze 22 variables in as few as 129 runs (Viana, 2016).

**Implementation:** Add a "Diversity Matrix" section to the plan output — a table showing each persona's position on each axis, with visual confirmation that coverage is even.

#### 2.1.4 Strengthen Anti-Clustering Constraints

**Current:** "No two personas should have the same job title" (weak constraint).

**Proposed:** "No two personas in the same segment may share more than 2 of: same age decade, same income bracket, same city type, same family structure, same discovery channel, same adoption stage."

**Why:** Naive prompting leads to mode collapse — simply asking for "diverse" personas produces populations clustered around stereotypical responses (Persona Generators, 2025). Structural constraints are the only reliable mitigation.

#### 2.1.5 Add Explicit Persona "Seeds" (Constraint Vectors)

**Current:** Persona outlines include name, age, city, job, key trait.

**Proposed:** Each outline includes a structured constraint vector:
```
Name: Darnell Pierre
Age: 52 | City: Memphis, TN | Job: warehouse supervisor
Income range: $38-48K | Household: divorced, 2 kids (shared custody)
Big Five: O:4 C:7 E:3 A:2 N:6
Decision style: satisficer | Adoption stage: late majority
Subscription count: 2 | Status quo bias: strong
Reference product: uses a free spreadsheet he built himself
Discovery channel: coworker mention at lunch
```

**Why:** The Personality Trap (2026) found that more creative freedom in persona generation produces more biased, less representative results. Anchoring personas in hard demographic tables prevents biases and makes synthetic samples robust across models and runs. Structured constraints are more effective than narrative descriptions for controlling output (SCOPE framework).

### 2.2 MEDIUM IMPACT

#### 2.2.1 Ground Names in Census Distributions

**Current:** "Full name (UNIQUE across the entire study — no name reuse, no similar names)."

**Proposed:** Add: "Names should reflect realistic demographic distributions for the target market. Use census-appropriate name frequencies. Not all names should be unusual or distinctive — some should be common names. Avoid generating only 'interesting' names."

**Why:** DeepPersona and PersonaGen research shows census-grounded names improve realism. LLMs default to generating distinctive/interesting names that don't reflect real population distributions.

#### 2.2.2 Add Forced Outcome Distribution

**Current:** "At least 2 segments will likely go unanimously for each option."

**Proposed:** Add explicit distribution targets:
- At least 25-35% of personas should reject ALL options or prefer the status quo
- At least 15% should be genuinely indifferent
- No more than 60% should choose the same option
- At least 2 personas should trigger a money-back guarantee / refund scenario

**Why:** Sycophancy research shows LLM personas default to positive engagement. NN/g found synthetic users "readily generate a long list of needs" and "seem to care about everything." Forcing negative outcomes counteracts this structural bias.

#### 2.2.3 Add "Information Access" Specification Per Persona

**Current:** All personas implicitly have access to the same product information.

**Proposed:** Specify per persona what they actually see/know:
- "Saw only the homepage hero and pricing table"
- "Read 3 blog posts and the FAQ"
- "Got a verbal description from a friend (partially accurate)"
- "Saw a competitor's comparison page first"

**Why:** SimToM (Theory of Mind) research shows that explicitly modeling what each persona knows and doesn't know produces more realistic behavior than giving all personas the same information set. Real users discover products through very different information paths.

---

## 3. PERSONA TEMPLATE (templates/persona.md)

### 3.1 HIGH IMPACT

#### 3.1.1 Add Anti-Sycophancy Instruction Block

**Current:** No explicit anti-sycophancy instructions.

**Proposed:** Add at the top of the template, before any content:

```markdown
## Simulation Integrity Rules

You are generating an analytical behavioral simulation, not a product pitch.

- This persona is NOT obligated to like any option. They may find all options unappealing, overpriced, irrelevant, or poorly designed.
- Skepticism and rejection are valid and expected outcomes. At least 30% of personas in any study should have serious objections.
- Do NOT default to agreement. If the price feels wrong for this persona's budget, say so directly. If the product doesn't solve their actual problem, they should notice.
- Frame the simulation as third-person behavioral analysis, not first-person helpfulness.
- Prioritize authenticity over positivity. A genuinely negative reaction is more valuable than a polished positive one.
```

**Why:** RLHF trains models to agree (Sharma et al., ICLR 2024). MIT found personalization features *increase* agreeableness (2026). Professional/authoritative framing reduces sycophancy by keeping the model in adviser mode rather than peer mode (Northeastern, 2026). Explicit rejection permission improved critical assessment in medical contexts (npj Digital Medicine, 2025).

#### 3.1.2 Add Behavioral Economics Parameters Section

**Current:** Section 2 (Behavioral Psychology) covers spending philosophy, subscriptions, formative memory.

**Proposed:** Add structured behavioral economics parameters drawn from the plan:

```markdown
### BEHAVIORAL ECONOMICS PROFILE

Based on this persona's background, model these specific decision patterns:
- **Reference point**: [current solution and its cost — what they compare against]
- **Loss aversion**: [low/medium/high — how much losing $X hurts vs. gaining $X]
- **Mental account**: [which spending category does this product fall into? what's the budget?]
- **Subscription fatigue**: [how many active subscriptions? what's their relationship with recurring payments?]
- **Status quo bias**: [how attached are they to their current solution?]
- **Time preference**: [impulsive vs. patient — do they optimize for now or later?]
- **Decision style**: [satisficer vs. optimizer — do they stop at "good enough"?]
- **Processing mode**: [System 1 gut reaction vs. System 2 analytical — for THIS product]
```

**Why:** LLMs don't reliably produce human behavioral biases without explicit instruction (17.8-57.3% consistency per arXiv:2509.22856). Prospect theory doesn't directly apply to LLMs (Yaron et al., 2025). Every dimension listed above is supported by extensive behavioral economics research as materially affecting purchase decisions.

#### 3.1.3 Add Verbalized Sampling Step

**Current:** Generation goes straight to writing the full persona.

**Proposed:** Add before the main generation:

```markdown
### PRE-GENERATION (do not include in output file)

Before writing the full persona, briefly brainstorm 3 distinct personality archetypes for this segment outline:
1. An archetype that would be enthusiastic about this product
2. An archetype that would be skeptical or resistant
3. A surprising archetype that breaks the expected pattern for this segment

For each, note: their core motivation, their emotional relationship with money, and one unexpected detail.

Then choose the one assigned by the plan's constraint vector (or the most interesting one if no specific assignment) and develop it fully.
```

**Why:** Verbalized Sampling increases diversity by 1.6-2.1x over direct prompting (arXiv:2510.01171). It's training-free, model-agnostic, and works at any temperature. This is the single highest-ROI diversity technique available through prompting alone.

#### 3.1.4 Restructure Prompt with XML Tags

**Current:** Flat markdown sections concatenated into a single prompt.

**Proposed:** Wrap sections in XML tags for Claude:

```xml
<persona-assignment>
[Persona outline + constraint vector — FIRST, for primacy]
</persona-assignment>

<study-context>
[Product description, study type, options]
</study-context>

<simulation-rules>
[Study-type-specific rules + anti-sycophancy block]
</simulation-rules>

<name-registry>
[Full name list — can go in the middle, less critical]
</name-registry>

<output-template>
[The persona template structure — LAST, for recency]
</output-template>
```

**Why:** Anthropic's docs recommend XML tags to structure prompts, reducing misinterpretation. The "Lost in the Middle" problem (Liu et al., TACL 2024) shows 30%+ performance degradation for information in the middle of long contexts. Place persona-specific content first and output template last.

#### 3.1.5 Add Consistency Self-Check

**Current:** No consistency verification.

**Proposed:** Add at the end of the template:

```markdown
### CONSISTENCY CHECK (verify before writing the file)

Before writing the final file, verify internally:
- Does the 12-month simulation's total spending align with this persona's stated income and budget?
- Does the NPS score match the emotional reactions described in the usage simulation?
- Does the referral behavior match the persona's personality? (introverts refer differently than extroverts)
- Do specific dates, amounts, and running totals in the simulation table add up correctly?
- Is the discovery story consistent with the persona's media diet and social circle?
- Does this persona sound distinctly different from the segment description? (they should be a specific person, not a segment archetype)

Fix any inconsistencies before writing.
```

**Why:** Self-Refine (Madaan et al., 2023) shows ~20% improvement from self-critique. LLMs exhibit 17.7% self-contradiction rate (Mun et al., 2023). This fits within the 15 max-turns budget already allocated for Generate.

### 3.2 MEDIUM IMPACT

#### 3.2.1 Add Chain-of-Feeling Scaffolding to Internal Monologues

**Current:** "Internal monologue during the decision (quoted, in their voice, with their vocabulary)."

**Proposed:** Replace with:

```markdown
**Internal monologue during the decision:**
Show the emotional arc of the decision:
1. Gut reaction (first 3 seconds — before any analysis)
2. Building considerations (what they notice, what they compare to)
3. The moment of doubt (what gives them pause — there must be one)
4. Resolution (what tips the scale, or why they walk away)

Use this persona's actual vocabulary and thought patterns. A software engineer's internal monologue reads differently from a pharmacy technician's. Show cognitive style, not just content.
```

**Why:** The Chain-of-Feeling approach (Synthetic Users) combines emotional states with personality traits for more human-like responses. MIRROR framework (2025) shows parallel cognitive and emotional threads produce more authentic reasoning. LLMs score 81% on emotional intelligence tests (PMC, 2025) — the capability is there, it just needs scaffolding.

#### 3.2.2 Add Contrastive Quality Examples

**Current:** The template says "specific enough to make predictions" and gives one example ("not 'she makes a moderate salary' but '$38,500/year'").

**Proposed:** Add 4-6 contrastive snippets at the top:

```markdown
## Quality Bar — Specific vs. Generic

SPECIFIC: "$38,500/year — $18.50/hour, the result of seven years of seniority at Presbyterian Hospital"
GENERIC: "She makes a moderate salary"

SPECIFIC: "A coworker's Slack message in the #random channel at 2:47pm on a Tuesday, between a meme and a link to a podcast"
GENERIC: "She found it through a colleague"

SPECIFIC: "She keeps a color-coded Google Sheet tracking every subscription charge, sorted by renewal date, that she reviews on the 1st of every month"
GENERIC: "She's organized about her finances"

SPECIFIC: "She tried Notion in 2022, got frustrated when the mobile app crashed during a grocery run, and hasn't trusted 'productivity apps' since"
GENERIC: "She's had mixed experiences with similar tools"
```

**Why:** Contrastive examples outperform standard few-shot prompting in both performance and token efficiency (arXiv:2403.08211). Near-miss negative examples are more influential than obviously incorrect ones (arXiv:2602.03516). Frame as positive guidance, not negative instructions (negative instructions get ignored — Gadlet, 2024).

#### 3.2.3 Avoid Numerical Anchoring in Persona Outlines

**Current:** Plan provides specific salary/age numbers per persona.

**Proposed:** Plan provides income *ranges* and job/location contexts. The generation call derives specific numbers through reasoning:

```
Instead of: "Income: $45,000"
Use: "Works as a dental hygienist in Memphis, TN with 7 years experience. Derive specific salary, tax situation, and monthly budget from this context."
```

**Why:** LLMs demonstrate strong anchoring bias on numbers present in prompts (arXiv:2412.06593). CoT reduces anchoring bias for some models but "ignore earlier conversation" instructions are ineffective. Providing ranges + context avoids clustering all personas in a segment at the same number.

#### 3.2.4 Add Anti-Homogenization Instructions

**Current:** No explicit instructions to vary linguistic style.

**Proposed:** Add:

```markdown
## Voice Differentiation

This persona must sound distinctly different from all other personas. Specifically:
- Avoid these common AI writing patterns: overuse of present participle clauses ("walking through the store, she noticed..."), balanced both/and constructions, overly hedged assessments, noun-heavy informational density.
- Match vocabulary level to this persona's education and profession.
- Match sentence complexity to their thinking style (analytical = longer, structured sentences; impulsive = shorter, fragmented thoughts).
- Internal monologues should use their actual vocabulary, including profanity, slang, or technical jargon where appropriate.
```

**Why:** PNAS (2025) found instruction-tuned models use present participle clauses at 2-5x human rates and nominalizations at 1.5-2x. The homogenizing effect of LLMs on creative output is well-documented (Cell, Trends in Cognitive Sciences, 2026). Explicit anti-pattern instructions break the default voice.

### 3.3 LOWER IMPACT

#### 3.3.1 Explicit Cultural Framing

**Current:** Cultural diversity is required but implementation is left open.

**Proposed:** For non-default-demographic personas, use explicit cultural perspective framing:

```
Instead of: "Hispanic woman, working class"
Use: "Write from the perspective of someone who grew up in a Mexican-American household in South Texas, where her abuela's opinions about money still echo in every purchase decision."
```

**Why:** Alignment with cultural values is improved more by explicit cultural perspective framing than by targeted prompt language or demographic labels (arXiv:2511.03980). Identity-coded approaches reduce stereotyping vs. explicit demographic labels (Cheng et al., 2024).

#### 3.3.2 Add "Deal-Breakers" Field

**Current:** Personas evaluate options but there's no concept of absolute rejection.

**Proposed:** Add to the persona outline:

```markdown
**Deal-breakers**: Specific conditions under which this persona rejects ALL options:
- [e.g., "Won't create another account / share another email address"]
- [e.g., "Walks away from any subscription over $15/month"]
- [e.g., "Refuses to use anything that requires a desktop app"]
```

**Why:** Real users have absolute deal-breakers that override all other considerations. Synthetic users "seem to care about everything" (NN/g). Explicit deal-breakers force the simulation to model realistic rejection.

---

## 4. WEAVE TEMPLATE (templates/weave.md)

### 4.1 Add Social Influence Modeling

**Current:** Weave adds cross-references and referral chains between personas.

**Proposed:** Add bounded confidence principles:

```markdown
### Social Influence Rules

When weaving connections, model how personas influence each other:
- Persona A only seriously considers Persona B's recommendation if they are in a similar-enough social position (bounded confidence).
- The referral message should MUTATE as it travels — approximately 60% of word-of-mouth stories are distorted in retransmission. The referrer emphasizes what THEY found interesting, not the product's full value prop.
- Referrers have different motivations: broadcasting (appearing savvy to many) vs. narrowcasting (helping one specific person). The motivation shapes what they say.
- MAINTAIN EACH PERSONA'S DISTINCT PERSPECTIVE. Do not harmonize disagreements. If Persona A loves the product and Persona B would be skeptical, the referral should create tension, not consensus.
```

**Why:** FDE-LLM research shows LLM opinion evolution matches real social dynamics when bounded confidence is applied. WOM research (PMC, 2023) found ~60% distortion rate in retransmission. LLM agents tend to align with numerically dominant groups (ACL 2025) — explicit instructions to preserve disagreement are necessary.

### 4.2 Add Trust-Based Network Topology

**Current:** Connections based on geography, profession, family, community.

**Proposed:** Add structural equivalence and trust:

```markdown
When identifying connections, consider:
- **Trust level**: How much does Persona A trust Persona B's judgment in this domain? A tech-savvy friend is trusted for SaaS recommendations; a grandmother is trusted for financial caution.
- **Structural equivalence**: People in similar positions (same job level, same life stage, same parenting situation) are more influenced by each other than by demographic similarity alone.
- **Referral chain quality**: Does the message travel cleanly? A simple value prop survives retransmission better than a complex one. If the product's story is too complicated to relay in one sentence, referral chains will break.
```

**Why:** AdoptAgriSim (2025) achieves 94.2% prediction accuracy using trust-based network structures. Structural equivalence is a stronger predictor of influence than demographic similarity (ABM adoption literature).

---

## 5. SYNTHESIS TEMPLATE (templates/synthesis.md)

### 5.1 Add Confidence Grading

**Current:** Synthesis produces a "verdict" with vote counts.

**Proposed:** Add explicit confidence levels per finding:

```markdown
### Confidence Framework

Grade each finding:
- **High confidence**: Strong agreement across segments, consistent with known behavioral economics, finding survived adversarial review
- **Moderate confidence**: Majority agreement with notable dissent, or finding relies on personas from well-represented demographics
- **Low confidence**: Split signals, relies heavily on underrepresented demographics, or single-segment finding

For each major conclusion, state: "Confidence: [HIGH/MODERATE/LOW] because [reason]."
```

**Why:** Huang et al. (2025) demonstrated that too many simulated responses produce overly narrow confidence sets. The Stanford study achieved r=0.85 at the aggregate level but individual-level prediction is weak (r=0.20, Columbia mega-study). Explicit confidence framing prevents overclaiming.

### 5.2 Report Splits, Don't Average Them Away

**Current:** "For each force driving the result, explain..."

**Proposed:** Add:

```markdown
When personas within a segment disagree:
- Report the split ratio explicitly (e.g., "3 of 5 personas in this segment preferred Option A")
- Identify the differentiating factor between those who split (what's different about the dissenters?)
- Note implications for targeting strategy (the split may reveal a sub-segment)
- Do NOT average conflicting signals into a single recommendation. Conflicting signals are a finding, not noise.
```

**Why:** Meta-analysis methodology (Cochrane Handbook) emphasizes heterogeneity testing before aggregation. Qualitative metasummary distinguishes frequency and intensity effect sizes. When signals conflict, reporting the conflict and its causes is the correct response.

### 5.3 Add Behavioral Economics Explanation Layer

**Current:** Synthesis explains "what" (which option won) but not always "why" in behavioral terms.

**Proposed:** Add:

```markdown
### Behavioral Mechanism Analysis

For each major finding, identify which behavioral economics mechanisms drove the result:
- Not just "Segment X preferred Option A" but "Segment X preferred Option A primarily due to [loss aversion around current solution / zero price effect / subscription fatigue / status quo bias], with [social proof / anchoring / framing] as secondary drivers."
- Identify which findings are robust to mechanism changes and which depend on a single behavioral assumption.
```

**Why:** The synthesis is more actionable when it explains the causal mechanisms, not just the outcomes. This also enables better adversarial review — the adversary can challenge specific mechanisms rather than just the conclusion.

### 5.4 Add Sycophancy Audit

**Current:** No check for systematic positive bias.

**Proposed:** Add:

```markdown
### Simulation Integrity Check

Before finalizing the synthesis, audit for these known simulation biases:
- **Sycophancy**: If more than 70% of personas are positive about any option, flag this as potentially sycophantic. Real product studies rarely show 70%+ enthusiasm.
- **Variance compression**: Are persona reactions clustered too tightly? Real users show much wider variance.
- **Missing negatives**: Did any persona express genuine confusion, frustration, or indifference? If not, the simulation lacks realism.
- **Demographic stereotyping**: Are personas from underrepresented groups described more homogeneously than others?
```

---

## 6. ARTIFACTS TEMPLATE (templates/artifacts.md)

### 6.1 Add Validation Plan Artifact

**Current:** Artifacts include copy, FAQ, marketing angles, referral messaging, objection handling.

**Proposed:** Add:

```markdown
### 6. Recommended Validation Plan

Based on the study findings, here's what to validate with real users:

For each key finding, provide:
- **What to test**: The specific hypothesis from the simulation
- **With whom**: Which real user segment to recruit
- **How**: Suggested method (5 user interviews, A/B test, survey question)
- **What would confirm**: What result would validate the simulation
- **What would invalidate**: What result would contradict the simulation
- **Priority**: High (launch-blocking) / Medium (informative) / Low (nice-to-know)
```

**Why:** Industry best practice (NN/g, Speero, EPAM) positions synthetic research as hypothesis generation. A validation plan bridges synthetic → real research. This is Facet's strongest differentiation opportunity vs. tools that just produce reports.

### 6.2 Add Confidence Disclaimer to All Artifacts

**Current:** No disclaimers.

**Proposed:** Every artifact section starts with a contextual confidence note:

```markdown
> **Note**: This [copy/FAQ/marketing angle] was derived from AI-simulated personas. It represents a directional hypothesis based on synthetic behavioral patterns. Validate with real users before committing resources.
```

---

## 7. ADVERSARIAL TEMPLATE (templates/adversarial.md)

### 7.1 Add Pre-Mortem Analysis

**Current:** Adversarial argues against the recommendation.

**Proposed:** Add:

```markdown
### Pre-Mortem

Imagine the recommended option was implemented and failed spectacularly 6 months later.
- What went wrong?
- Which assumption proved false?
- Which persona segment behaved differently than simulated?
- What market condition changed?
- What competitor move invalidated the recommendation?

Write this as a specific, plausible failure narrative — not a list of abstract risks.
```

**Why:** Pre-mortem technique overcomes reluctance to express reservations and cognitive biases like overconfidence (Veinott, ISCRAM 2010). More effective at surfacing risks than standard devil's advocacy because it reframes from "what might go wrong" to "what went wrong."

### 7.2 Require Alternative Recommendation

**Current:** "Does the recommendation survive?"

**Proposed:** Add:

```markdown
### The Alternative

You must propose a specific alternative recommendation — not just "the other option" but a different strategic approach entirely. This could include:
- A hybrid of the tested options
- A different pricing/feature/copy strategy not tested
- A phased rollout starting with a different segment
- A completely different approach to the same business problem

The alternative must be supported by specific persona evidence from the study.
```

**Why:** Schwenk & Cosier (1990) meta-analysis found that authentic alternative proposals are more effective than assigned devil's advocacy. The adversary should provide a genuinely creative alternative, not just critique.

### 7.3 Add LLM Bias Audit

**Current:** Adversarial checks for confirmation bias in the study design.

**Proposed:** Add:

```markdown
### Simulation Bias Audit

Specifically check for known LLM simulation biases:
- Which personas seem unrealistically positive? (sycophancy)
- Are persona reactions clustered too tightly around the average? (variance compression)
- Are marginalized group personas described more homogeneously than others? (stereotyping)
- Do all personas reason like educated, urban, progressive individuals? (WEIRD bias)
- Are any behavioral biases (loss aversion, anchoring, status quo bias) applied inconsistently?
- Does the simulation miss DIY/workaround solutions that real users would have?
```

**Why:** Each of these is a documented, empirically-validated failure mode. The adversarial phase is the natural place to check for them. Without explicit checking, they persist into the final recommendation.

### 7.4 Multiple Adversarial Angles

**Current:** Single devil's advocate.

**Proposed:** Structure the adversarial review around 3 distinct perspectives:

```markdown
Write your counterargument from three distinct perspectives:

1. **The Market Skeptic**: "The market dynamics don't support this." Challenge the revenue modeling, competitive assumptions, and growth projections.

2. **The User Advocate**: "Real users wouldn't behave this way." Challenge the realism of persona behaviors, identify missing user segments, and flag where synthetic reasoning diverges from likely real behavior.

3. **The Methodology Critic**: "The simulation itself is flawed." Check for sycophancy, variance compression, demographic bias, and other known LLM simulation failure modes.
```

**Why:** Each angle targets a different vulnerability. A single adversary tends to pick the most obvious attack and miss structural issues. Multiple perspectives ensure broader coverage.

---

## 8. STUDY TYPE RULES

### 8.1 Pricing (study-types/pricing.md)

**Add:**
- Explicit subscription fatigue context (average household dropped from 4.1 to 2.8 subscriptions in 2024-2025)
- Zero price effect modeling — the transition from free to any nonzero price is qualitatively different, not just quantitatively
- Flat-rate bias — most personas should prefer flat-rate over per-use even when per-use is cheaper for their usage
- Charm pricing effects — $9.99 vs $10 should produce measurably different reactions
- Decoy/compromise effect for multi-tier pricing
- Payment pain and timing — per-use creates maximum coupling; annual prepaid creates minimum
- Frame pricing as directional ranges, not point estimates: "Real willingness-to-pay data requires real users"
- Ground personas in real income distribution data (like Cambium AI does)

### 8.2 Copy (study-types/copy.md)

**Add:**
- Pairwise comparison is more reliable than absolute scoring for subjective evaluations
- Framing effect — gain frames vs. loss frames should produce systematically different reactions
- Elaboration Likelihood Model — high-involvement personas process centrally; low-involvement process peripherally
- Construal Level Theory — abstract messaging for future-oriented personas; concrete for ready-to-buy
- Reactance — controlling language ("you must") triggers resistance in high-autonomy personas
- Cialdini principle mapping — identify which principles are active in each copy variant
- Emotional language analysis — 60% of copy effectiveness comes from emotional language (Persado)

### 8.3 Features (study-types/features.md)

**Add major caveat:**
```
IMPORTANT: Feature prioritization is the weakest use case for synthetic personas. NN/g found that synthetic users "care about everything equally" and cannot effectively prioritize.

This study type should produce:
- Feature REACTIONS by segment (how each segment responds to each feature)
- Potential CONCERNS and OBJECTIONS per feature
- Feature INTERACTION analysis (which features must ship together, which conflict)

This study type should NOT produce:
- Ranked priority lists (unreliable with synthetic personas)
- Willingness-to-pay per feature (unreliable)
- Definitive "must build" vs "skip" recommendations (needs real validation)
```

Also add Kano model categorization:
```
For each feature, each persona should categorize it as:
- Must-Be (expected, absence causes dissatisfaction)
- Performance (more is better, linearly)
- Attractive (delighter, unexpected value)
- Indifferent (doesn't affect satisfaction)
- Reverse (causes dissatisfaction when present)

Different personas will categorize the same feature differently.
```

---

## 9. ORCHESTRATOR (sim.sh)

### 9.1 Add Persona Validation Step

After `run_generate()`, before `run_weave()`, add `run_validate()`:

```bash
run_validate() {
    # Single Claude call reads all personas and checks:
    # - Sycophancy rate (% positive verdicts)
    # - Pairwise similarity (any two personas too similar?)
    # - Numerical plausibility (financials within range for demographics)
    # - Internal consistency (stated income vs. spending patterns)
    # - Diversity score (coverage of attribute space)
    # Outputs validation report + list of personas to regenerate
}
```

### 9.2 Add Config Neutrality Check

Before `run_plan()`, add a check that options in the config are described with equal detail and neutral framing. If one option has 3x more description than another, warn the user.

**Why:** Confirmation bias research (arXiv:2504.09343) shows AI models mirror the language and assumptions in prompts. If the config describes Option A more favorably, all downstream outputs will reflect that bias.

### 9.3 Version-Lock Templates

All template files should be copied into the study output directory at the start of a run, creating an immutable record of what templates were used. Any template change mid-study invalidates comparison.

**Why:** Prompt sensitivity research shows that even minor rewording can shift results by up to 76 accuracy points in some contexts (arXiv:2310.11324).

---

## 10. CROSS-CUTTING CONCERNS

### 10.1 Positioning and Framing

Based on the research, Facet should explicitly position as:

> **Strategic pre-testing** — a tool that narrows the solution space before you commit real resources, not a replacement for talking to humans.

It is **good for**: directional insights, hypothesis generation, rapid screening, copy variant testing, segment identification, identifying objections and concerns.

It is **not good for**: final pricing decisions, feature prioritization rankings, deep emotional insight, non-Western/underrepresented populations, unprecedented product categories, go/no-go launch decisions.

### 10.2 What Differentiates Facet

Based on the commercial landscape analysis, Facet's unique position:
- **Transparent methodology**: open templates, no black box
- **CLI-native**: developer/PM-friendly, runs on user's own AI credits
- **Honest about limitations**: explicit confidence grading, mandatory disclosure, validation plan generation
- **Anti-sycophancy by design**: structural (not just prompting) mitigations throughout the pipeline
- **Behavioral economics grounded**: explicit bias parameters, not just demographic profiles

### 10.3 Priority Order for Implementation

If implementing everything at once is impractical:

**Week 1 — Highest leverage, lowest effort:**
1. Anti-sycophancy instruction block in persona template
2. Behavioral economics parameters in plan + persona templates
3. Contrastive quality examples in persona template
4. Consistency self-check in persona template
5. Mandatory disclosure headers

**Week 2 — High leverage, moderate effort:**
6. XML tag restructuring of persona prompt
7. Verbalized sampling step
8. Confidence grading in synthesis
9. Pre-mortem in adversarial template
10. Study type rule updates (pricing, copy, features)

**Week 3 — Medium leverage, higher effort:**
11. Latin Hypercube Sampling in plan
12. Persona validation phase in orchestrator
13. Split-half reliability option
14. Social influence modeling in weave
15. Validation plan artifact

---

## Sources Referenced

This plan synthesizes findings from 6 research reports totaling ~490 sources. Key citations by recommendation:

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
- Commercial landscape: Simile, Aaru, Ditto, Evidenza, Qualtrics, Synthetic Users, 16 tools analyzed
