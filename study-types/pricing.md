# Pricing Study Simulation Rules

## What This Study Tests

Two or more pricing models for the same product. The goal is to determine which model:
1. Converts more users
2. Generates more revenue
3. Produces better referral dynamics
4. Creates higher user satisfaction (NPS)

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

When writing internal monologues, consider:
- **Loss aversion**: Upfront fees feel like losses; commissions on savings feel like "house money"
- **Payment timing**: Paying before value (subscription) vs. after value (commission) creates different psychological frames
- **Anchoring**: What does the persona compare the price to? (monthly subscriptions, hourly wage, specific purchases)
- **Subscription fatigue**: How many subscriptions does this persona already have? What's their tolerance?
- **The word "free"**: How does this persona react to "free" claims? Skepticism vs. relief vs. suspicion
- **Social proof**: Does the pricing model make the referral story simpler or more complex?

### Simulation Realism Rules

- Price drops, savings, and value events should follow realistic distributions (not every interaction is a win)
- Some personas should have ZERO value events in some months (quiet periods are realistic)
- The "best" persona should save/gain 5-10x more than the "worst" — realistic variance
- At least one persona should trigger a money-back guarantee or refund scenario
- At least one persona should churn (stop using) under one model but not the other
