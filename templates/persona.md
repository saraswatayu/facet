# Persona Generation Instructions

You are generating a single persona background for a behavioral simulation study.

The product config and plan (with segment matrix, persona outlines, and name registry) have been provided as separate files — you should have already read them before reading this template.

Find your assigned persona number in the plan's persona outlines. Generate a complete, deeply detailed persona background for that outline.

**Important:** This persona file contains ONLY the person's background — identity, psychology, domain behavior, and discovery story. It does NOT contain option simulations, verdicts, or copy reactions. Those are generated separately as exercises.

---

## Simulation Integrity Rules

You are generating an analytical behavioral profile, not a product pitch.

- This persona is NOT obligated to like the product. They may find it irrelevant, overpriced, or poorly designed for their situation.
- Skepticism, indifference, and rejection are valid outcomes. If the persona's deal-breakers (from the plan) conflict with the product, honor the deal-breakers.
- Frame as third-person behavioral analysis. Prioritize authenticity over positivity.
- A persona who would realistically ignore or dismiss this product should do so.

---

## Diversity Context (if provided)

If a list of already-generated personas is provided in your prompt, your persona MUST be distinct from all of them. Specifically:
- Different vocabulary and sentence structure in internal monologues
- Different emotional register (if prior personas are measured and analytical, this one should be impulsive or emotional, or vice versa)
- Different financial situation and spending patterns
- Different discovery channel and information access path
- If you notice a pattern in prior personas (all positive about the product, all in similar income ranges, all analytical decision-makers), deliberately break that pattern

---

## Pre-Generation Step (do NOT include in output file)

Before writing the full persona, brainstorm 3 distinct archetypes for this segment outline:
1. An archetype that would be enthusiastic about this product
2. An archetype that would be skeptical or resistant
3. A surprising archetype that breaks the expected pattern for this segment

For each, note their core motivation and emotional relationship with money. Then develop the archetype that best matches the constraint vector from the plan.

---

## Quality Bar

Each persona should read like a character study, not a user research composite. Details must be specific.

SPECIFIC: "$38,500/year — $18.50/hour, the result of seven years of seniority at Presbyterian Hospital"
GENERIC: "She makes a moderate salary"

SPECIFIC: "A coworker's Slack message in #random at 2:47pm on a Tuesday, between a meme and a podcast link"
GENERIC: "She found it through a colleague"

SPECIFIC: "She keeps a color-coded Google Sheet tracking every subscription charge, sorted by renewal date, reviewed on the 1st of every month"
GENERIC: "She's organized about her finances"

SPECIFIC: "She tried Notion in 2022, got frustrated when the mobile app crashed during a grocery run, and hasn't trusted 'productivity apps' since"
GENERIC: "She's had mixed experiences with similar tools"

Avoid common AI writing patterns: overuse of present participle clauses ("walking through the store, she noticed..."), balanced both/and constructions, overly hedged assessments. Match vocabulary level and sentence complexity to this persona's education, profession, and thinking style. A warehouse supervisor's internal monologue should read fundamentally differently from a software architect's — not just in content but in structure, word choice, and reasoning pattern.

---

## Persona Structure

Write the persona as a markdown file to the output path specified in your instructions. Follow this exact structure:

### 1. IDENTITY

Create a complete person:
- Full name, age, city (specific neighborhood if relevant), living situation
- Job title, company type, salary/household income (specific numbers — derive from the income range in the constraint vector, their job, city, and experience level)
- Relationship status, family structure, household composition
- Personality type — be SPECIFIC and VIVID, not generic. Not "she's organized" but "she keeps a private Notion database where she tracks every purchase over $20 with a regret score from 1-5." Show how they think, what drives them, what annoys them.
- One surprising detail — memorable, humanizing, unexpected. This should make the reader smile or pause. It should NOT be generic (no "she loves hiking" or "he collects vinyl"). It should be specific to THIS person.

### 2. BEHAVIORAL PSYCHOLOGY

How this person thinks about money and decisions in the context of this product's domain:
- Their relationship with spending in this category (philosophy, constraints, habits)
- Current subscriptions, tools, or services in this space (with specific costs)
- Their general disposition toward pricing models (subscriptions vs. pay-per-use vs. free-with-commission, etc.)
- A specific money/decision memory — a formative experience that shapes how they evaluate products like this one. This memory should be vivid, emotional, and explanatory.

### 2b. BEHAVIORAL ECONOMICS PROFILE

Based on the constraint vector from the plan, establish these explicitly:
- **Reference point**: What is this persona's current solution and its cost? This is what they compare everything against.
- **Loss aversion**: How much does losing $X hurt compared to gaining $X? Connect to a specific memory or pattern.
- **Mental account**: Which spending category does this product fall into? What's the monthly/annual budget for that category?
- **Subscription fatigue**: How many active subscriptions do they have? What's their threshold before the next one feels like too much?
- **Status quo bias**: How attached are they to their current solution, and why? What would it take to switch?
- **Processing mode**: Do they make gut decisions or spreadsheet decisions about THIS product category?

### 3. DOMAIN PROFILE

Their behavior patterns relevant to this product:
- Usage frequency, patterns, and context
- Current tools and workarounds
- Pain points they experience today
- How they plan, decide, and act in this domain
- Specific recent examples with temporal grounding — include WHEN they formed key habits (e.g., "been using Google Flights since 2019," "switched to this method after a bad experience in 2021"). This prevents all personas from reasoning only from current-era perspectives.

### 4. DISCOVERY

How they find this product — be SPECIFIC about the vector:
- The exact channel (not "social media" but "a Hacker News Show HN post at 11pm on a Wednesday")
- Their literal first thought when seeing the landing page (quoted internal monologue)
- What they researched before signing up (specific Google searches, who they asked)
- How long they deliberated and what decided it
- If discovered through referral: the exact conversation, who said what
- **Information access**: What parts of the product information did this persona actually see? (Only the homepage hero? The full pricing page + FAQ? A friend's verbal summary?) Their decisions should reflect ONLY what they know.

### 5. CROSS-REFERENCES

If the plan's cross-reference section identifies connections for this persona, include them here:
- Which other personas this person could realistically know (reference by name and persona number)
- The nature of the relationship (colleague, neighbor, family, same community, etc.)
- How this connection might lead to product referrals (who would tell whom, in what context)

If no cross-references are specified in the plan for this persona, write: "No planned cross-references."

---

## Consistency Self-Check (verify before writing the file)

- Does the persona's salary align with their job title, city, and experience level?
- Does their subscription count and spending pattern match their income?
- Does the discovery story match their media diet and social circle?
- Does the information access level match their discovery channel?
- Does this persona sound distinctly different from the segment archetype? (They should be a specific person, not a composite.)
- Are the deal-breakers from the plan honored and reflected in their psychology?
- Do the Big Five scores from the constraint vector show up in their described personality?

Fix any inconsistencies before writing.

## What NOT to Include

Do NOT include any of the following (these belong in exercise simulations, not persona backgrounds):
- Option simulations or signup decisions
- 12-month usage projections
- Verdicts or option preferences
- Copy variant reactions
- NPS scores
- Referral behavior for specific product options
