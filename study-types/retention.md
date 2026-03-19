# Retention Study Simulation Rules

## Important Caveat

Retention simulations model the psychological arc of continued use — not real usage data. LLMs cannot experience feature fatigue, encounter bugs in production, or feel the slow drift of a product from "essential" to "background noise." This study identifies which retention STRATEGIES sustain engagement and which psychological forces drive churn — not exact retention curves.

## What This Study Tests

Two or more retention strategies, product changes, or lifecycle interventions for an existing product. The goal is to determine which approach:
1. Sustains engagement beyond the initial excitement phase
2. Minimizes voluntary churn
3. Produces the highest renewal/repurchase rates
4. Creates the strongest resistance to competitive alternatives

## Exercise-Specific Outcome Targets

- At least 2 personas should churn (for different reasons)
- At least 1 persona should almost churn but be retained by a specific mechanism
- At least 1 persona should become a power user / advocate
- The satisfaction trajectory should NOT be flat — model the emotional peaks and valleys
- Some personas should experience "quiet quitting" (still paying, barely using)

## Simulation Framework

### Per-Persona Retention Journey

For each retention option, simulate a 12-month arc:

#### Month 1-2: Honeymoon Phase

- **Initial excitement level** (1-10): How enthusiastic is this persona post-onboarding?
- **Usage frequency**: Daily? Weekly? Already tapering?
- **Peak moment**: The single best experience in the first 60 days — what was it, and how did it feel?
- **First friction point**: Something that annoyed them, confused them, or didn't work as expected. How did they react?
- **Hedonic adaptation onset**: When does the novelty start to fade? Some personas adapt in days (low Openness, utilitarian mindset); others stay excited for weeks (high Openness, exploratory).

#### Month 3-6: The Danger Zone

This is where most churn happens. Simulate:
- **Routine or rut?** Has usage become habitual (good) or mechanical (bad)?
- **The competitor whisper**: Does this persona encounter a competitor during this period? A friend's recommendation, an ad, a blog post? How do they react?
- **Value realization check**: Does the persona feel they're getting their money's worth? Calculate: perceived value received vs. cumulative cost paid. If the ratio drops below 1, churn risk spikes.
- **Sunk cost activation**: If the persona has invested effort (data, configuration, learning), does sunk cost keep them? Or has the investment been too small to matter?
- **Feature discovery**: Do they find features they didn't know about? Does this renew interest or feel like complexity creep?
- **The "quiet quit" scenario**: Still paying, usage dropping. Internal monologue: "I should cancel this... but I might need it next week."

#### Month 7-12: Equilibrium or Exit

- **Renewal decision**: At the billing anniversary, does this persona actively choose to stay, passively continue, or cancel? Model the decision arc (gut reaction → consideration → resolution).
- **Post-purchase rationalization**: If they stay, what story do they tell themselves about why it's worth it? (Festinger's cognitive dissonance — the more they paid, the more they rationalize)
- **If they churn**: What was the final trigger? Not the underlying reason (that built over months) but the specific moment that made them cancel. The straw that broke the camel's back.
- **Win-back susceptibility**: After churning, how susceptible is this persona to a win-back offer? What offer would work?

### Emotional Arc Mapping

Plot the persona's satisfaction over 12 months as key moments:

| Month | Event | Satisfaction (1-10) | Emotional State |
|-------|-------|--------------------:|-----------------|
| 1 | First success | ? | ? |
| 2 | First friction | ? | ? |
| ... | ... | ? | ? |
| 12 | Renewal decision | ? | ? |

The arc should NOT be monotonic. Real users experience peaks and valleys. Apply the **peak-end rule**: the persona's overall satisfaction is disproportionately shaped by (a) the single most intense moment and (b) the most recent experience — not the average.

### Behavioral Economics Cues

Apply these mechanisms based on each persona's profile:

- **Hedonic adaptation**: The excitement of a new product wears off as it becomes routine. Products that introduce variety resist adaptation better than static ones. Intrinsically motivated activities (the work itself is rewarding) buffer against adaptation better than extrinsically motivated ones (rewards, notifications).
- **Sunk cost fallacy**: 68% of people continue investments due to prior spend, regardless of future value. Older personas (46+) are more susceptible (80%). Brand-loyal personas persist even longer. But sunk cost creates a paradox: they stay AND resent it, building cancellation pressure.
- **Peak-end rule**: Overall satisfaction is determined by the emotional peak and the ending, not the average experience. A product that's consistently "fine" with a bad ending (billing issue, poor support) will be remembered worse than one with ups and downs that ends well.
- **Post-purchase rationalization**: Buyers downplay flaws and emphasize benefits to justify past decisions. The more expensive the product, the stronger the rationalization. This keeps some personas paying long after the rational case has eroded.
- **Loss aversion at renewal**: Canceling means losing access to everything built/configured. The prospect of loss should hurt ~2x the equivalent gain. Personas who invested heavily in setup feel this more acutely.
- **Trust decay**: Trust is asymmetric — built slowly, destroyed rapidly. A single bad experience (data loss, billing error, poor support) can undo months of positive interaction. The longer the relationship, the more forgiving the persona — but not infinitely.
- **Subscription fatigue**: The ambient pressure of "too many subscriptions" grows over time. A product that was tolerable at 3 subscriptions becomes expendable at 6. Model this as a rising baseline pressure, not a sudden event.
- **Regret aversion**: Some personas stay because canceling would confirm they made a bad choice signing up. Avoiding regret is a separate force from sunk cost — it's about protecting self-image, not money.
- **Status quo bias at renewal**: For auto-renewing subscriptions, the default is to continue. Canceling requires active effort. Passive retention is real but fragile — these personas leave the moment a competitor makes switching easy.

### Churn Taxonomy

When a persona churns, categorize the reason:

| Category | Description | Win-back difficulty |
|----------|-------------|-------------------|
| **Value gap** | Product doesn't deliver enough value for the price | Medium — price reduction or feature addition could work |
| **Competitor pull** | Found something better | Hard — must demonstrate superiority |
| **Life change** | No longer needs the product (job change, life event) | Low — not a product failure |
| **Death by friction** | Accumulated small annoyances | Medium — requires product fixes, not just offers |
| **Subscription fatigue** | Cutting costs broadly, not product-specific | Easy — a discount or pause option may retain |
| **Quiet quit** | Forgot they were paying; cancels upon noticing | Easy — re-engagement before billing can save |
| **Trust breach** | Single negative event destroyed trust | Very hard — requires genuine repair |

### Aggregate Analysis

In the synthesis, produce:
- **Retention curve**: % of personas still active at month 3, 6, 9, 12 under each strategy
- **Churn reason distribution**: How many churned for each category above?
- **Satisfaction arc**: Average satisfaction over time, with standard deviation showing persona spread
- **Peak-end analysis**: Which strategy produces the best peaks and best endings?
- **Sunk cost vs. genuine satisfaction**: Of the personas who stayed, how many stayed because they wanted to vs. because switching felt harder than staying?
- **Win-back opportunity map**: Which churned personas are recoverable, and what would it take?
- **Recommended retention strategy**: Synthesize the best mechanisms from each option
- **The honest retention rate**: Separate "genuinely retained" (active, satisfied) from "passively retained" (paying, not using). The second group is a ticking time bomb.
