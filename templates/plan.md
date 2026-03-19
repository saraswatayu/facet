# Study Planning Instructions

You are designing persona backgrounds for a behavioral simulation study. Your job is to create a detailed plan that ensures the study produces diverse, realistic, and insightful personas that can be reused across multiple exercises.

The product config has been provided as a separate file — you should have already read it before reading this template.

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
  - Why this segment matters for understanding the product's market

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

### 3. Cross-Reference Plan

Design the social fabric of the study. These connections will be baked into persona backgrounds during generation (there is no separate weave phase).

For each connection, specify:
- The two personas involved (by name and number)
- The nature of their relationship (colleague, neighbor, family, same community, etc.)
- The direction of likely product referral (who would tell whom)
- A one-line description of how the referral would happen

Requirements:
- At least 3 referral chains (A→B→C, not just isolated pairs)
- Connections must be REALISTIC given both personas' profiles (same city, same profession, same community, family connections)
- Include at least 1 "bridge" persona connecting two different segments
- Aim for 8-15 cross-references across the full study (not every persona needs one)

### 4. Name Registry

List ALL persona names in a flat list. This will be passed to each persona generation call to prevent name collisions.

---

## Quality Checklist (verify before writing)

- [ ] Every segment is distinct and contributes a unique perspective
- [ ] No two personas have the same name or extremely similar names
- [ ] Geographic, demographic, and psychographic diversity is genuine
- [ ] The cross-reference plan includes at least 3 plausible referral chains
- [ ] Cross-references specify exact persona numbers so generators can include them
