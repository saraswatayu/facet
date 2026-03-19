# Pricing Study Simulation Rules

## Important Caveat

Pricing simulations produce DIRECTIONAL signals, not precise willingness-to-pay data. Real WTP requires real users. This study identifies which pricing MODEL resonates, which segments are price-sensitive, and what psychological barriers exist — not exact price points.

## What This Study Tests

Two or more pricing models for the same product. The goal is to determine which model:
1. Converts more users
2. Generates more revenue
3. Produces better referral dynamics
4. Creates higher user satisfaction (NPS)

## Exercise-Specific Outcome Targets

These apply to simulations, not persona backgrounds:
- At least 1 persona should trigger a money-back guarantee or refund scenario
- At least 1 persona should churn (stop using) under one model but not the other
- Price drops, savings, and value events should follow realistic distributions (not every interaction is a win)
- Some personas should have ZERO value events in some months (quiet periods are realistic)
- The "best" persona should save/gain 5-10x more than the "worst" — realistic variance

## Simulation Framework

### Per-Persona Metrics to Track

For each pricing option, simulate:
- **Signup decision**: Does this persona convert? Internal monologue during the decision.
- **Usage over 12 months**: 3-8 specific interactions with dates, amounts, and outcomes
- **12-month totals**:
  - Gross value received (total savings, features used, outcomes achieved)
  - Total cost to user (subscription fees, commissions, per-use charges)
  - Net value to user (gross - cost)
  - Effective cost rate (cost / gross value, as percentage)
- **Renewal decision**: Continue, upgrade, downgrade, or churn? With reasoning.
- **NPS score**: 0-10 with specific justification
- **Referral behavior**: Who they tell, how they describe it, referral story quality

### Crossover Analysis

If the pricing options include a flat fee vs. percentage/usage-based model:
- Calculate the **crossover point**: the annual value level where user preference switches
- Below crossover: percentage model is cheaper for user
- Above crossover: flat fee model is cheaper for user
- Map each persona's expected annual value relative to the crossover point

### Revenue Modeling

For aggregate analysis, project:
- **Conversion rate per 1K visitors** under each model
- **Revenue per 1K visitors** (conversion rate × per-user revenue)
- **Average revenue per paying user** under each model
- **Referral coefficient**: how many new users does each paying user bring?

### Behavioral Economics Cues

When writing internal monologues, actively apply these mechanisms based on each persona's behavioral economics profile:

- **Loss aversion**: Upfront fees feel like losses; commissions on savings feel like "house money." Apply asymmetrically — losing $X should hurt ~2x more than gaining $X feels good.
- **Payment timing**: Paying before value (subscription) vs. after value (commission) creates different psychological frames. Pre-payment creates commitment; post-payment creates coupling anxiety.
- **Anchoring**: What does the persona compare the price to? Their reference point from the background defines this.
- **Subscription fatigue**: Average US household dropped from 4.1 to 2.8 active subscriptions (2024-2025). Each persona's existing subscription count matters — the threshold for "one more" is real and personal.
- **The zero price effect**: The jump from $0 to any nonzero price is qualitatively different from $10 to $20. Free generates positive emotional response disproportionate to economic value. Model this as a categorical shift, not a linear one.
- **Flat-rate bias**: Most people prefer flat-rate over per-use pricing even when per-use is objectively cheaper for their usage. Driven by insurance effect (cost certainty), overestimation of future usage, and "taximeter anxiety" (the meter running feeling).
- **Social proof**: Does the pricing model make the referral story simpler or more complex?
- **Charm pricing**: $9.99 vs $10.00 should produce measurably different gut reactions (System 1 processing). Round prices signal premium; charm prices signal value.
- **Decoy/compromise effect**: If there are 3+ tiers, the middle tier attracts disproportionate preference. An asymmetrically dominated option shifts choice toward the "target" tier.
- **Payment coupling**: Per-use payments create maximum pain-of-paying (tight coupling to consumption). Annual prepaid creates minimum (decoupled, "already paid for"). Monthly subscriptions fall between.
