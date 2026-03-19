# Per-Persona Simulation Instructions

You are running a behavioral simulation for a single persona through a product exercise. The persona's background (identity, psychology, domain profile, discovery) has already been generated separately. Your job is to simulate this persona's experience with each option being tested.

The exercise config, persona background file, and study-type rules have been provided as separate files — you should have already read them before reading this template.

---

## Quality Bar

This simulation must read as a continuation of the persona's story. The persona's voice, vocabulary, financial constraints, and behavioral patterns established in the background file must carry through every internal monologue and decision. Numbers must be specific and internally consistent — if the persona earns $38,500/year, their spending decisions must reflect that reality. Do not flatten the persona into a generic consumer. Maintain every quirk, every constraint, every formative memory.

---

## Your Task

Read the persona background file and the exercise config. Then simulate this persona's experience with each option and write the results to the output path specified in your instructions.

The simulation file should begin with a header identifying the persona (name, ID, segment) and then proceed through the following sections.

---

## Simulation Structure

### OPTION SIMULATIONS

**Create one section per option defined in the exercise config.** For each option:

#### Signup/Purchase Decision

- Internal monologue during the decision (quoted, in this persona's voice, with their vocabulary and thought patterns)
- Whether they convert and why/why not — the reasoning must connect to specific details from their background (income, psychology, current subscriptions, formative money memories)
- If they don't convert: what would change their mind? What's the specific counterfactual?

#### 12-Month Usage Simulation (if they convert)

- 3-8 specific, quantified interactions over 12 months, each with a date, amounts, and outcome details
- A simulation table showing each interaction, the outcome, and running totals:

| Month | Event | Gross Value | Cost to User | Net Value | Running Net |
|-------|-------|-------------|--------------|-----------|-------------|

- Emotional reactions at key moments:
  - The first success (how they feel, who they tell, what they think)
  - The first friction point (what goes wrong, how they react)
  - The moment of realization (when they decide this was worth it — or wasn't)

#### 12-Month Totals

| Metric | Value |
|--------|-------|
| Gross value received | $ |
| Total cost to user | $ |
| Net value to user | $ |
| Effective cost rate | % |

All four numbers are mandatory. The effective cost rate is (total cost / gross value) as a percentage. If gross value is zero, the effective cost rate is N/A.

#### Renewal/Repurchase Decision

- Internal monologue at the renewal moment (quoted, in character)
- Whether they continue, upgrade, downgrade, or churn — and the specific reason
- What would change their decision in the opposite direction?

#### Referral Behavior

- Who they tell — specific people from their life (use names and relationships, not "friends" or "coworkers")
- How they describe it — the exact words they'd use, in their register
- The referral story — does it travel cleanly or get muddled? Is the value proposition easy to retell?
- Referral multiplier — how many people hear about it, and how many of those would actually try it?

#### NPS Score (0-10)

- The specific score
- Why this number and not one higher — what's the ceiling?
- Why this number and not one lower — what's the floor?

---

### VERDICT

After all option simulations, this section summarizes the persona's overall position:

- **Preference:** Which option this persona prefers and why (in their own voice, quoted — 2-4 sentences)
- **Revenue comparison:** Which option generates more revenue for the company from this persona (show the math)
- **Referral likelihood:** Which option makes this persona more likely to refer others (and why — connect to the referral story quality)
- **Representative quotes:** One quote per option — something this persona would actually say to a friend about each option. These should be distinct in tone and content, not just reworded versions of the same sentiment.

---

### COPY VARIANT REACTIONS (only if copy variants are defined in the exercise config)

For each copy variant defined in the exercise config:

- **Internal monologue** when reading it (in character, using their vocabulary and thought patterns — this should feel different from persona to persona)
- **Scores** on 4 dimensions (0-10 each):
  - **Clarity**: How quickly they understand what the product does and costs
  - **Trust**: How much they believe the claims
  - **Motivation**: How strongly they want to act
  - **Shareability**: How likely they are to forward/screenshot/quote this to someone
- **Primary objection**: The one thing that gives them pause (specific to this persona, not generic)
- **CTA reaction**: Would they click the CTA? (yes/no/maybe, with reasoning that connects to their psychology)

After all variants: **Final ranking** (best to worst for THIS persona) with one-line reasoning per variant.

---

## Consistency Rules

- Every dollar amount must be traceable. If the persona saves $180 on a flight, that number must appear in the simulation table, the 12-month totals, and the verdict's revenue comparison.
- The persona's behavior must be consistent with their background. A persona who described subscription fatigue in their psychology section should show that fatigue in their signup decision. A persona who keeps a regret-score spreadsheet should reference it.
- Usage patterns must match the persona's domain profile. A persona who flies twice a year should not have eight flight interactions. A persona who described themselves as a power user should not have two.
- Emotional reactions must reflect the persona's established personality, not generic consumer reactions. A skeptic should stay skeptical even when satisfied. An enthusiast should find things to love even when frustrated.
- NPS scores must be justified by the simulation, not assigned arbitrarily. A persona who had three friction points and nearly churned should not score 9/10.
