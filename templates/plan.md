# Study Planning Instructions

You are designing a behavioral simulation study. Your job is to create a detailed plan that ensures the study produces diverse, realistic, and insightful personas.

The study config and study-type rules have been provided as separate files — you should have already read them before reading this template.

---

## Your Task

Produce a comprehensive study plan. The plan must include ALL of the following sections:

### 1. Segment Matrix

Design the requested number of demographic/psychographic segments relevant to this product and market.

Requirements:
- Each segment must be DISTINCT — different financial constraints, motivations, media diets, adoption patterns
- Each segment must be named descriptively (e.g., "Budget-Conscious Single Parents" not "Segment 3")
- Include at least:
  - 1-2 segments of power users / high-value customers
  - 1-2 segments of skeptics / hard-to-convert users
  - 1-2 segments of price-sensitive / budget-constrained users
  - 1 segment of accidental/unusual discoverers (wildcards)
  - Segments that represent different discovery channels (organic, referral, social, search)
- For each segment, provide:
  - Name and one-line description
  - Key demographic traits (income range, age range, location type)
  - Key psychographic traits (decision-making style, risk tolerance, tech comfort)
  - Expected behavior with this product (power user? skeptic? champion? churner?)
  - Why this segment matters for the business question being asked

### 2. Persona Outlines

For each segment, create the requested number of persona outlines.

Requirements for EACH persona:
- Full name (UNIQUE across the entire study — no name reuse, no similar names)
- Age, city (specific), job title
- Key distinguishing trait (one sentence that makes this persona different from others in the same segment)
- Expected relationship with the product (1-2 sentences)
- Discovery vector (how they'll find the product)

Diversity requirements across the full study:
- Geographic diversity (not all coastal cities)
- Age distribution (20s through 70s)
- Income diversity (minimum wage through high earners)
- Family structure diversity (single, couples, families, multi-generational)
- Cultural/ethnic diversity (organic, not tokenistic)
- Mix of genders, relationship structures, and living situations
- No two personas should have the same job title

### 3. Simulation Parameters

Define the quantitative framework for the simulations:
- What metrics should be tracked per option? (e.g., cost to user, value received, net benefit, ROI)
- What constitutes "success" for each option from the user's perspective?
- What constitutes "success" for each option from the company's perspective?
- Is there a crossover point where user preference switches between options? If so, define the framework for calculating it.
- What referral/viral dynamics should be modeled?

### 4. Cross-Reference Plan

Design the social fabric of the study:
- Which personas could realistically know each other? (same city, same profession, same community, family connections)
- What referral chains are plausible? (e.g., tech-savvy family member -> overwhelmed parent)
- Which segments have group dynamics that amplify or dampen adoption? (wedding groups, friend groups, workplace teams, family group chats)
- Which personas could serve as "bridge" personas connecting two segments?

### 5. Name Registry

List ALL persona names in a flat list. This will be passed to each persona generation call to prevent name collisions.

---

## Quality Checklist (verify before writing)

- [ ] Every segment is distinct and contributes a unique perspective
- [ ] No two personas have the same name or extremely similar names
- [ ] Geographic, demographic, and psychographic diversity is genuine
- [ ] At least 2 segments will likely go unanimously for each option (creates clear signal)
- [ ] At least 1 segment will be closely split (creates nuance)
- [ ] The cross-reference plan includes at least 3 plausible referral chains
- [ ] Simulation parameters are specific enough to produce quantitative comparisons
