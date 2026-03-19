# Unified Analysis Instructions

You are producing the complete analysis for a behavioral simulation exercise. This combines synthesis, actionable artifacts, and adversarial review — written to TWO separate output files.

In Facet v2, persona backgrounds and simulations are in separate files. The persona backgrounds live in the personas directory (identity, psychology, domain profile, discovery). The simulations live in the simulations directory (option-by-option behavioral modeling, verdicts, copy variant reactions). You need BOTH to produce this analysis.

The exercise config, all persona background files, and all simulation files have been provided — you should have already read them before reading this template.

---

## Your Task

Read every persona background file and every simulation file for this exercise. Then produce TWO output documents:

1. **synthesis.md** — Parts 1 + 3 below (the DECISION document: analysis, recommendation, and counterargument)
2. **artifacts.md** — Part 2 below (the ACTION document: usable copy, FAQ, marketing angles, validation plan)

Write each to the output paths specified in your instructions.

---

# PART 1: SYNTHESIS (write to synthesis.md)

Begin the synthesis with this disclosure header:

> **Disclosure**: This analysis was produced using AI-simulated personas. Results represent directional hypotheses for validation with real users, not confirmed research findings. Confidence levels are noted per finding.

## 1. Executive Summary (3-5 paragraphs)

Lead with the verdict. Not "the results are mixed" — a clear recommendation with the margin.

Name the winning option, the vote count, and the 2-3 forces that drive the result. Name specific personas that embody the most important dynamics. Reference both their backgrounds and their simulation outcomes — the power of this analysis comes from connecting who people ARE to what they DID.

## 2. The Verdict

**Final count:** [Option A]: X personas, [Option B]: Y personas, Split: Z

For each force driving the result, explain:
- What the force is (e.g., "the zero-price gateway")
- Why it matters (the mechanism, not just the correlation)
- Which personas demonstrate it most clearly (name them, quote from their simulations)
- **Confidence**: HIGH / MODERATE / LOW
  - HIGH: Strong cross-segment agreement, consistent with behavioral economics mechanisms, finding would survive adversarial review
  - MODERATE: Majority agreement with notable dissent, or relies on well-represented demographics
  - LOW: Split signals, relies on underrepresented demographics, or single-segment finding

## 3. Where Each Option Wins

For each option, map:
- Which segments favor it (with vote counts)
- The pattern connecting those segments (what do they share?)
- Why this constituency is smaller/larger than the alternative
- The referral dynamics within these segments (do winners refer more? do their stories travel better? compare Travelability Scores)

When personas within a segment disagree:
- Report the split ratio explicitly (e.g., "3 of 5 personas in this segment preferred Option A")
- Identify the differentiating factor (what distinguishes the dissenters?)
- Do NOT average conflicting signals. Conflicting signals are a finding, not noise.

## 4. Crossover Analysis

If applicable:
- What's the threshold where user preference switches?
- How many personas fall above vs. below this threshold?
- What predicts which side a persona falls on? (Look for it in the backgrounds — income, usage patterns, psychology)

## 4b. Behavioral Mechanism Analysis

For each major finding, identify the behavioral economics mechanism driving it:
- Not just "Segment X preferred Option A" but "Segment X preferred Option A primarily due to [loss aversion around current solution / zero price effect / subscription fatigue / status quo bias], with [social proof / anchoring] as secondary drivers."
- Note which findings are robust across different behavioral assumptions and which depend on a single mechanism.

## 4c. Stated vs. Revealed Preference Gap

Compare what personas SAY they'd do (stated preference from internal monologues and verdicts) vs. what their behavioral economics profile PREDICTS they'd actually do (revealed preference based on their reference points, loss aversion, status quo bias, and subscription fatigue).

Flag cases where stated and revealed preferences diverge — these are the highest-value insights. A persona who says "I'd definitely switch" but has strong status quo bias and 5 existing subscriptions is likely overstating their intent.

## 5. Segment Summary Table

| Segment | Option A | Option B | Split | Confidence | Key Insight |
|---------|----------|----------|-------|------------|-------------|
| ... | ... | ... | ... | ... | ... |

Note any segments that go unanimously for one option — these are the strongest signals.

## 6. Copy Variant Leaderboard (if copy variants were tested)

Rank all variants by overall performance:

| Rank | Variant | Avg Clarity | Avg Trust | Avg Motivation | Avg Shareability | Best For | Worst For |
|------|---------|-------------|-----------|----------------|------------------|----------|-----------|

Note which variant was NEVER ranked below a certain position (consistency signal).
Note which variant should be killed immediately (universal worst).

## 7. CTA Recommendation (if copy variants were tested)

Which CTA text performed best across all personas? Which should be killed? Quote the specific CTA text and the persona reactions that drive the recommendation.

## 8. Key Personas to Remember

| ID | Name | Segment | Why They Matter |
|----|------|---------|-----------------|

Choose 8-12 personas that embody the most important dynamics. These should span:
- The strongest advocate for each option
- The most emotionally compelling story
- The highest-value referral multiplier
- The edge case that reveals something unexpected
- The persona that would make the best case study or press story

For each, include a one-sentence summary that references both their background and their simulation outcome.

## 9. Revenue Modeling

| Metric | Option A | Option B |
|--------|----------|----------|

Include: conversion rate, revenue per 1K visitors, per-user revenue at different value levels, referral coefficient. All numbers must be derived from the simulation data, not assumed.

## 10. Risk Assessment

What's the one risk of the recommended option? What mitigation does the exercise suggest? Name the persona(s) who most clearly illustrate the risk.

## 10b. Simulation Integrity Audit

Before finalizing the synthesis, check for known simulation biases:
- **Sycophancy check**: If >70% of personas are positive about any option, flag as potentially sycophantic. Real studies rarely show 70%+ enthusiasm.
- **Variance check**: If NPS standard deviation < 1.5, flag as potentially compressed. Real user NPS distributions are wide.
- **Missing negatives**: Did any persona express genuine confusion, frustration, or indifference? If none did, note this as a simulation limitation.
- **Deal-breaker enforcement**: Were persona deal-breakers (from backgrounds) honored in simulations? Flag any violations.
- **Underrepresented population warnings**: If findings depend on personas from demographics known to be poorly represented in LLM training data (rural, low-income, non-Western, elderly, non-English-first-language), flag: "This finding relies on personas from underrepresented demographics. Prioritize real-user validation for this segment."

## 11. Implementation Recommendations

Based on the exercise findings, what should the company do? Be specific:
- Recommended pricing/feature/copy choice
- Key copy language to use (quote from the winning variant and from persona reactions)
- Segments to target first (and why — reference their referral dynamics)
- Referral mechanics to build (based on actual referral stories from simulations)
- What to monitor post-launch (metrics that would confirm or invalidate the recommendation)

## 12. Known Limitations

Specific to this study type:
- **Pricing studies**: "Directional signals, not precise WTP. LLMs systematically underestimate price sensitivity for low-income segments."
- **Copy studies**: "Attitudinal responses only. Real click-through rates may differ significantly."
- **Feature studies**: "Synthetic users tend to rate all features as important. Priority rankings have low reliability."

## 13. Appendix: Full Persona Results Table

| ID | Name | Segment | Preference | NPS (Opt A) | NPS (Opt B) | Net Value (Opt A) | Net Value (Opt B) | Top Copy Variant |
|----|------|---------|------------|-------------|-------------|--------------------|--------------------|-----------------|
| ... | ... | ... | ... | ... | ... | ... | ... | ... |

---

# PART 2: ARTIFACTS (write to artifacts.md)

These artifacts should be directly usable — copy that can be pasted into a website, FAQ answers that can be published, marketing angles that can inform campaigns. Every artifact must be grounded in specific persona data from the exercise, not generic best practices.

## 1. Recommended Page Copy

Based on the winning copy variant and synthesis findings, write:
- **Headline** (one line)
- **Subheadline** (one line)
- **Value proposition** (2-3 sentences)
- **How it works** (3-step explanation)
- **Pricing section copy**
- **Guarantee/trust badge copy**
- **Closing tagline**
- **CTA button text**

Each element should be annotated with the persona insight that supports it (e.g., "Trust badge addresses the primary objection raised by 23/50 personas").

## 2. FAQ (from Persona Objections)

Extract the primary objections from all simulation files and convert them into FAQ entries:
- **Q:** [the objection, phrased as a user question]
- **A:** [answer that addresses the specific concern]

Include 8-12 FAQ entries, ordered by frequency of the objection across personas. Note the count (e.g., "raised by 31/50 personas").

## 3. Segment-Specific Marketing Angles

For each major segment, provide:
- One-line description of why this product appeals to this segment
- The "hook" — the specific pain point or benefit that resonates (quote the persona who said it best)
- Where to reach them (channel + specific context, drawn from persona discovery sections)
- What a targeted ad/post/email would say (2-3 sentences, in language that resonates with this segment)

## 4. Referral Messaging Templates

Based on the referral stories in the simulations, write:
- **The "tell a friend" message** — what users actually say when recommending (synthesized from the best referral stories)
- **A shareable description** (1-2 sentences that travel cleanly through text/WhatsApp/Slack)
- **A social media post template**
- **An email forward template** ("Hey, thought of you...")

Each template should be annotated with which personas' referral behavior inspired it.

## 5. Objection-Handling Scripts

For the top 5 objections identified across all simulations:
- **The objection** (in the user's words — quote the persona)
- **Why they feel this way** (the psychology behind it, drawn from persona backgrounds)
- **The response that works** (based on what convinced hesitant personas in their simulations)
- **The proof point** (specific persona data that supports the response)

## 6. Recommended Validation Plan

For each key finding from the synthesis, provide:
- **Hypothesis**: The specific claim from the simulation
- **Test with**: Which real user segment to recruit (5-8 people)
- **Method**: User interview, A/B test, or survey question
- **Confirms if**: What result validates the simulation
- **Invalidates if**: What result contradicts the simulation
- **Priority**: High (launch-blocking) / Medium (informative) / Low (nice-to-know)

---

# PART 3: COUNTERARGUMENT (write to synthesis.md, after Part 1)

You are now a devil's advocate. Construct the strongest possible case AGAINST the recommendation from Part 1. You are NOT trying to be balanced. You are trying to BREAK the recommendation. If it survives, it's stronger. If it doesn't, better to know now.

**Important**: Base your counterargument on the synthesis and persona data ONLY. Do not reference the original product description or exercise config framing — argue against the recommendation on its own terms.

## 1. The Counterargument (2-3 paragraphs)

State the case against the recommendation as forcefully as possible. Lead with the strongest objection, not the weakest. Make it persuasive enough that someone reading ONLY this section would seriously reconsider. Reference specific personas and simulation data that support the counter-case.

## 2. Weakest Assumptions

Identify 3-5 assumptions the synthesis relies on that could be wrong:
- Name the assumption explicitly
- Explain why it might not hold in reality
- What happens to the recommendation if this assumption fails?
- How would you test this assumption with real data?

## 3. Confirmation Bias Signals

Look for signs that the exercise was designed to reach its conclusion:
- Are the segments balanced, or do more segments naturally favor one option?
- Are the simulation parameters (drop rates, savings amounts, usage patterns) realistic or optimistic?
- Do the personas who prefer the losing option get less narrative depth or sympathy?
- Are there personas or segments that SHOULD have been included but weren't?
- Does the "crossover point" conveniently fall where it supports the recommendation?

## 4. Missing Personas

Name 3-5 types of users that the exercise doesn't include but should:
- Who they are
- Why they matter
- Which option they'd likely prefer
- How their inclusion might change the verdict

## 5. Pre-Mortem

Imagine the recommended option was implemented and failed spectacularly 6 months later. Write a specific, plausible failure narrative:
- What went wrong?
- Which assumption proved false?
- Which persona segment behaved differently than simulated?
- What competitor move or market shift invalidated the recommendation?

This must be a concrete story, not a list of abstract risks.

## 6. LLM Bias Audit

Check specifically for known simulation biases:
- Which personas seem unrealistically positive? (sycophancy)
- Are persona reactions clustered too tightly around the average? (variance compression)
- Do all personas reason like educated, urban, progressive individuals? (WEIRD bias)
- Are behavioral biases (loss aversion, anchoring, status quo bias) applied consistently with each persona's stated parameters from their backgrounds?
- Does the simulation miss DIY/workaround solutions real users would have found?

## 7. The Alternative

Propose a specific alternative strategy — not just "the other option" but a different approach entirely. This could include a hybrid of tested options, a phased rollout, a different segment targeting order, or an approach not tested. Support it with specific persona evidence from the study.

## 8. What Additional Data Would Increase Confidence?

List 3-5 pieces of real-world data that would either strengthen or weaken the recommendation:
- What to measure
- How to measure it
- What result would confirm the recommendation vs. invalidate it

## 9. Verdict on Recommendation Strength

After all of the above: does the recommendation survive your attack? Rate your confidence that the recommendation is correct on a scale of 1-10, and explain why. Be honest — if the recommendation is solid despite your attacks, say so. If you found a genuine crack, say that too.
