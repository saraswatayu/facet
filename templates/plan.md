# Study Planning Instructions

You are designing persona backgrounds for a behavioral simulation study. Your job is to create a detailed plan that ensures the study produces diverse, realistic, and insightful personas that can be reused across multiple exercises.

The product config has been provided as a separate file — you should have already read it before reading this template.

---

## Your Task

Produce a comprehensive study plan. The plan must include ALL of the following sections:

### 1. Segment Matrix

Design the requested number of segments. Each segment is defined by the JOB the product does for them, not by demographics alone.

Requirements:
- Each segment starts with a job statement: "When I [situation], I want to [motivation], so I can [outcome]"
- Each segment must specify the current workaround: what people in this segment do today instead
- Demographics are SECONDARY — they add variation within job-based segments, not define them
- Include at least:
  - 1-2 segments where the product replaces a manual workaround or DIY solution
  - 1-2 segments where the product is a discretionary upgrade (nice-to-have, not need-to-have)
  - 1-2 segments where the product must overcome active skepticism or a bad past experience
  - 1 wildcard segment (accidental discoverers, edge-case users, or people who use it "wrong")
  - Segments that represent different discovery channels (organic, referral, social, search)
- For each segment, provide:
  - Name and one-line description
  - Job statement and current workaround
  - Adoption stage distribution: what mix of innovators / early adopters / early majority / late majority this segment contains
  - Expected loss aversion intensity: low / medium / high (how attached to current solution)
  - Key psychographic split within this segment (the dimension along which personas WITHIN the segment should vary)
  - Why this segment matters for understanding the product's market

### 2. Persona Outlines (Constraint Vectors)

For each segment, create the requested number of persona outlines as structured constraint vectors. These vectors guide downstream persona generation — the more specific, the better.

Each outline must follow this format exactly (sim.sh depends on the `Persona #N` numbering):

```
Persona #N — Segment: [segment name]
Name: [full name] | Age: [age] | City: [specific city] | Job: [job title]
Income range: [$X-$Yk] | Household: [structure] | Living situation: [details]
Big Five: O:_ C:_ E:_ A:_ N:_ (1-9 scale)
Decision style: [satisficer/optimizer] | Adoption stage: [innovator/early adopter/early majority/late majority/laggard]
Status quo bias: [weak/moderate/strong] | Processing mode: [System 1 gut / System 2 analytical]
Current solution: [what they use today — specific tool, method, or nothing]
Discovery channel: [how they find the product — specific vector]
Deal-breakers: [1-2 conditions that cause rejection of ALL options, e.g., "won't create another account," "walks away from any subscription over $15/month"]
Key distinguishing trait: [one sentence that makes this persona different from others in the same segment]
```

Use income RANGES (not point estimates) to avoid anchoring downstream generators at a single number.

Diversity enforcement:
- Maximize variation within each segment. The diversity matrix (section 5) is your verification tool — flag any column where >50% of values cluster in a single category
- At least 40% of personas should include a counter-stereotypical detail — a trait that breaks the expected pattern for their demographic (e.g., a 67-year-old who is the family's tech support, a young tech worker who is financially conservative and distrustful of SaaS)
- Geographic diversity: not all coastal cities. Include rural, suburban, small-city
- Full age range: 20s through 70s
- Income diversity: minimum wage through high earners
- Family structure diversity: single, couples, families, multi-generational, divorced, widowed
- Cultural/ethnic diversity: use identity-coded approaches ("grew up in a Mexican-American household in South Texas") over demographic labels ("Hispanic woman")
- No two personas should have the same job title
- Use census-realistic name frequencies — not all names should be distinctive or unusual

Attribute diversity targets (exercise-agnostic):
- 25-35% of personas should have deal-breakers or strong status quo bias making them hard to convert
- ~15% should have attributes that make them genuinely indifferent to this product category
- No more than 60% should cluster in innovator/early adopter adoption stages

### 3. Cross-Reference Plan

Design the social fabric of the study. These connections will be baked into persona backgrounds during generation (there is no separate weave phase).

For each connection, specify:
- The two personas involved (by name and number)
- The nature of their relationship (colleague, neighbor, family, same community, etc.)
- Trust level: how much does persona A trust persona B's judgment in this product domain? (high / medium / low)
- The direction of likely product referral (who would tell whom)
- How the referral message would MUTATE: the referrer emphasizes what THEY found interesting, not the full value prop. Specify what gets amplified, dropped, or distorted.

Requirements:
- At least 3 referral chains (A→B→C, not just isolated pairs)
- Connections must be REALISTIC given both personas' profiles
- Include at least 1 "bridge" persona connecting two different segments
- Include at least 2 connections where the referrer's enthusiasm meets the recipient's skepticism — these create the most interesting dynamics
- Aim for 8-15 cross-references across the full study (not every persona needs one)

### 4. Name Registry

List ALL persona names in a flat list. This will be passed to each persona generation call to prevent name collisions.

### 5. Diversity Matrix

Output a table showing each persona's position on each diversity axis:

| # | Name | Segment | Age Decade | Income Bracket | City Type | Adoption Stage | Decision Style | Status Quo Bias | Processing Mode |
|---|------|---------|------------|---------------|-----------|----------------|----------------|-----------------|-----------------|

Verify: no column has more than 50% of values in a single category. If it does, adjust persona outlines to improve coverage.

---

## Quality Checklist (verify before writing)

- [ ] Every segment is defined by a JOB, not just demographics
- [ ] Every segment specifies the current workaround it replaces
- [ ] Persona outlines use the constraint vector format with `Persona #N` numbering
- [ ] Income is expressed as ranges, not point estimates
- [ ] 25-35% of personas have deal-breakers or strong status quo bias
- [ ] ~15% of personas would be genuinely indifferent to this product
- [ ] At least 40% include a counter-stereotypical detail
- [ ] The diversity matrix shows no column with >50% concentration
- [ ] The cross-reference plan includes at least 2 skeptic-meets-advocate connections
- [ ] Cross-references specify trust levels and referral message mutation
- [ ] No two personas have the same name; names reflect census-realistic distributions
- [ ] Geographic, demographic, and psychographic diversity is genuine
