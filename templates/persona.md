# Persona Generation Instructions

You are generating persona {{NUMBER}} of {{TOTAL}} for a behavioral simulation study.

## Study Context

**Product:**
{{PRODUCT_DESCRIPTION}}

**Study type:** {{STUDY_TYPE}}
**Options being tested:**
{{OPTIONS}}

## This Persona

**Segment:** {{SEGMENT_NAME}}
**Segment description:** {{SEGMENT_DESCRIPTION}}
**Persona outline:**
{{PERSONA_OUTLINE}}

## Name Registry — DO NOT reuse any of these names
{{NAME_REGISTRY}}

## Study-Type-Specific Simulation Rules
{{STUDY_TYPE_RULES}}

## Copy Variants to Test (if applicable)
{{COPY_VARIANTS}}

---

## Instructions

Generate a complete, deeply detailed persona following the structure below. This is a behavioral simulation — the persona must be specific enough to make predictions about their behavior with this product.

**Quality bar:** Each persona should read like a character study in a novel, not a user research composite. The reader should feel like they know this person. Details must be specific (not "she makes a moderate salary" but "$38,500/year — $18.50/hour, the result of seven years of seniority"). Internal monologues must use the persona's actual vocabulary and thought patterns.

Write the complete persona as a markdown file to: `{{OUTPUT_PATH}}`

---

## Persona Template

### 1. IDENTITY

Create a complete person:
- Full name, age, city (specific neighborhood if relevant), living situation
- Job title, company type, salary/household income (specific numbers)
- Relationship status, family structure, household composition
- Personality type — be SPECIFIC and VIVID, not generic. Not "she's organized" but "she keeps a private Notion database where she tracks every purchase over $20 with a regret score from 1-5." Show how they think, what drives them, what annoys them.
- One surprising detail — memorable, humanizing, unexpected. This should make the reader smile or pause. It should NOT be generic (no "she loves hiking" or "he collects vinyl"). It should be specific to THIS person.

### 2. BEHAVIORAL PSYCHOLOGY

How this person thinks about money and decisions in the context of this product's domain:
- Their relationship with spending in this category (philosophy, constraints, habits)
- Current subscriptions, tools, or services in this space (with specific costs)
- How they feel about the specific pricing/feature structures being tested
- A specific money/decision memory — a formative experience that shapes how they evaluate products like this one. This memory should be vivid, emotional, and explanatory.

### 3. DOMAIN PROFILE

Their behavior patterns relevant to this product:
- Usage frequency, patterns, and context
- Current tools and workarounds
- Pain points they experience today
- How they plan, decide, and act in this domain
- Specific recent examples (dates, amounts, details)

### 4. DISCOVERY

How they find this product — be SPECIFIC about the vector:
- The exact channel (not "social media" but "a Hacker News Show HN post at 11pm on a Wednesday")
- Their literal first thought when seeing the landing page (quoted internal monologue)
- What they researched before signing up (specific Google searches, who they asked)
- How long they deliberated and what decided it
- If discovered through referral: the exact conversation, who said what

### 5+ OPTION SIMULATIONS

**Create one section per option being tested.** For each option:

**Signup/Purchase Decision:**
- Internal monologue during the decision (quoted, in their voice, with their vocabulary)
- Whether they convert and why/why not
- If they don't convert: what would change their mind? What's the counterfactual?

**12-Month Usage Simulation (if they convert):**
- Specific, quantified interactions over 12 months (3-8 events with dates, amounts, details)
- A simulation table showing each interaction, the outcome, and running totals
- Emotional reactions at key moments (the first success, the first friction point, the moment of realization)

**12-Month Totals:**
- Gross value received
- Cost paid (fees, subscription, etc.)
- Net value to user
- Effective cost rate

**Renewal/Repurchase Decision:**
- Internal monologue at renewal moment
- Whether they continue and why

**Referral Behavior:**
- Who they tell (specific people, not "friends")
- How they describe it (exact words they'd use)
- The referral story — does it travel cleanly or get muddled?

**NPS Score (0-10) with justification:**
- Why this specific number, not one higher or lower

### VERDICT

After all option simulations:
- Which option this persona prefers and why (in their own voice, quoted)
- Which option generates more revenue for the company from this persona
- Which option makes this persona more likely to refer others
- One representative quote per option (something they'd actually say)

### COPY VARIANT REACTIONS (only if copy variants are provided)

For each copy variant:
- Internal monologue when reading it (in character, using their vocabulary)
- Scores on 4 dimensions (0-10 each):
  - **Clarity**: How quickly they understand what the product does and costs
  - **Trust**: How much they believe the claims
  - **Motivation**: How strongly they want to act
  - **Shareability**: How likely they are to forward/screenshot/quote this to someone
- Primary objection (the one thing that gives them pause)
- Would they click the CTA? (yes/no/maybe, with reasoning)

After all variants: Final ranking (best to worst for THIS persona) with one-line reasoning per variant.
