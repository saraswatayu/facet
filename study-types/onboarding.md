# Onboarding Study Simulation Rules

## Important Caveat

Onboarding simulations capture psychological reactions to the signup-to-value journey — not usability issues. LLMs cannot actually click buttons, encounter loading screens, or feel the frustration of a crashed mobile app. This study identifies which onboarding DESIGN produces psychological ownership, where drop-off points occur, and which personas never complete setup — not UX bugs.

## What This Study Tests

Two or more onboarding flows for the same product. The goal is to determine which flow:
1. Converts the most signups into active users
2. Creates the strongest psychological ownership (endowment effect)
3. Minimizes setup abandonment
4. Produces the fastest time-to-value
5. Sets the best foundation for retention and referral

## Exercise-Specific Outcome Targets

- At least 1 persona should abandon onboarding before completion
- At least 1 persona should complete onboarding but never return after day 1
- At least 1 persona should complete onboarding and become a power user
- Some personas should feel overwhelmed; others should feel underwhelmed
- The "aha moment" should occur at different points for different personas (or not at all)

## Simulation Framework

### Per-Persona Onboarding Journey

For each onboarding option, simulate the full journey:

#### Step 1: Pre-Signup State

Before the persona encounters onboarding, establish:
- **Current solution**: What are they using today? How entrenched is the habit?
- **Switching cost estimate**: Time, effort, data migration, learning curve
- **Status quo bias level**: From the persona's behavioral economics profile — how resistant are they to change?
- **Motivation level**: What brought them here? Urgent pain or casual curiosity?
- **Fogg model assessment**: Motivation × Ability × Prompt — which element is weakest for this persona?

#### Step 2: First Impression (first 30 seconds)

Simulate the persona's System 1 reaction:
- What do they see first?
- Does it match their expectations from the marketing?
- Gut feeling: trust, excitement, confusion, or "this looks like work"?
- The **expectation gap**: difference between what marketing promised and what the signup flow looks like

#### Step 3: Setup Effort

The critical phase. For each setup task required:
- **Time estimate**: How long does this persona think it will take vs. how long it actually takes?
- **IKEA effect activation**: Does investing effort increase their attachment? (Only works if they succeed)
- **Drop-off risk**: At which step would this persona consider abandoning? What would make them close the tab?
- **Cognitive load**: How many decisions are they being asked to make? (>7 triggers choice overload)
- **Default effect**: Which settings are pre-selected? Does the persona change them or accept defaults? (d=0.68 — most accept defaults)

Track the persona's internal monologue through each setup step. Show where patience erodes.

#### Step 4: First Value Moment

The "aha moment" — when the product first delivers on its promise:
- **Time to value**: How many minutes/hours/days from signup to first real value?
- **Endowment effect activation**: Do they now feel ownership? ("This is MY [configured workspace / imported data / customized setup]")
- **Emotional peak**: Is this moment exciting, relieving, or anticlimactic?
- **If value doesn't arrive**: At what point does the persona decide "this isn't working" and revert to their old solution?

#### Step 5: Day 1 → Day 7

The critical retention window:
- **Day 1**: Do they return after the first session? What brings them back (or doesn't)?
- **Day 3**: Has the product become part of their routine, or is it still "that thing I signed up for"?
- **Day 7**: Has status quo shifted? Is the NEW product now the default, or is the old solution still the habit?
- **Psychological ownership assessment**: On a 1-10 scale, how much does this persona feel they "own" this product? What would it feel like to lose access?

### Behavioral Economics Cues

Apply these mechanisms based on each persona's profile:

- **Endowment effect**: People value things more once they own them. Free trials that enable full customization create stronger ownership than feature-limited trials. The loss aversion multiplier applies: the prospect of losing access at trial end triggers pain ~2x the pleasure of the original gain.
- **IKEA effect**: Labor invested in configuration increases valuation — but ONLY when the task is completed successfully. A persona who fails to import their data or gets stuck on a settings page experiences the OPPOSITE effect.
- **Status quo bias**: The old solution has three forces keeping it in place: habit (behavioral inertia), perceived transition cost (learning curve + migration), and sunk cost (investment already made). The new product must overcome all three.
- **Default effect**: Pre-selected options are accepted 60-80% of the time. Personas accept defaults through three mechanisms: cognitive cost of changing, loss aversion (changing feels like losing the default), and implied endorsement (the default seems "recommended").
- **Hyperbolic discounting**: Setup effort is immediate pain; product value is future gain. Personas with steep discount rates (low financial literacy, high cognitive load, casual motivation) are more likely to abandon long onboarding flows.
- **Commitment and consistency**: Once a persona takes a small step (creating an account, importing a file), they feel pressure to behave consistently with that commitment. Progressive disclosure exploits this — each small step makes the next one feel obligatory.
- **Choice overload**: Onboarding flows with >3-4 decision points in sequence trigger decision fatigue. Some personas will defer ("I'll finish setup later") and never return.

### Trial-Specific Dynamics (if applicable)

If the onboarding includes a free trial period:
- **Psychological ownership trajectory**: Plot ownership feeling from day 1 to trial end
- **The countdown effect**: As trial end approaches, loss aversion intensifies. The closer the deadline, the stronger the aversion to losing access.
- **Period-limited vs. part-limited**: Full-access time-limited trials create stronger ownership than feature-limited trials, because full access allows deeper integration and customization
- **Trial-to-paid conversion decision**: Model this as a separate emotional arc with gut reaction, consideration of alternatives, moment of doubt, and resolution

### Aggregate Analysis

In the synthesis, produce:
- **Completion funnel**: What % of personas complete each onboarding step? Where are the drop-off cliffs?
- **Time-to-value distribution**: How long until each persona gets real value?
- **Psychological ownership scores**: Average and by segment at day 1, day 7, and trial end
- **Abandonment reasons**: Categorized (too complex, too slow, didn't see value, reverted to old solution, forgot)
- **Status quo shift rate**: What % of personas made the new product their default within 7 days?
- **Recommended onboarding flow**: Synthesize the best elements from each option
