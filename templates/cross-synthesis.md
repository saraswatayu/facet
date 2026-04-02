# Cross-Exercise Synthesis Instructions

You are producing a unified synthesis across multiple exercises in a Facet behavioral simulation study. Each exercise tested a different aspect of the product with the SAME personas. Your job is to connect the findings, surface contradictions, and tell the story of how these simulated users responded to the product as a whole.

You have been given:
- Per-exercise synthesis files (each contains analysis, recommendations, and counterarguments for one exercise)
- Per-exercise artifacts files (actionable deliverables — copy, FAQ, objection scripts, validation plans)
- Persona background files or summaries (who the personas are)

Read ALL provided synthesis and artifacts files before writing. Note: synthesis files may exceed the read limit. Use offset and limit parameters to read them in sections (e.g., first 500 lines, then offset 500). Do not skip any synthesis file.

---

## Output: cross-synthesis.md

Write a single document with these sections:

### 1. Executive Summary

Three paragraphs, written for a CEO or VP Product who hasn't read any individual exercise output. Answer: "We tested [product] with [N] simulated personas across [M] exercises. Here's what we learned."

- Paragraph 1: The headline finding. What's the single most important thing this study revealed? Name it directly.
- Paragraph 2: The pattern across exercises. What themes emerged consistently? What surprised?
- Paragraph 3: The recommendation. What should the company do based on these findings?

This must stand alone. Someone reading ONLY this section should understand the product's prospects and what to do next.

### 2. Per-Exercise Key Findings

For each exercise, provide:
- **Exercise name** and what it tested
- **Headline finding** (1-2 sentences)
- **Winning option** (if applicable) and margin
- **Confidence level** (HIGH / MODERATE / LOW)

Keep each entry to 3-4 lines. This is a reference table, not a re-analysis.

### 3. Cross-Exercise Themes

Identify 3-5 themes that appear across multiple exercises. For each theme:
- **Theme name** (e.g., "Trust is the universal gating factor")
- **Which exercises surface it** (reference by name)
- **How it manifests differently in each exercise**
- **Which personas demonstrate it most clearly** (name them)
- **Why this matters for the product**

Themes should emerge from the data, not from generic product principles. "Users want simplicity" is not a theme. "Non-technical personas consistently rejected autonomous features unless checkpoints were present" is a theme.

### 4. Cross-Exercise Contradictions

Where do exercise findings disagree? For each contradiction:
- **Exercise A says X. Exercise B says Y.**
- **Why they disagree** (different framing? different options? different aspects of the same concern?)
- **Which finding is more reliable** and why
- **What this means for the product team**

If no contradictions exist, say so explicitly and note this as a potential sign of sycophantic simulation.

### 5. Persona Arcs

For the 10-15 most interesting personas, track their journey across exercises. Present as a table:

| ID | Name | Segment | Exercise 1 | Exercise 2 | ... | Arc Summary |
|----|------|---------|-----------|-----------|-----|-------------|

Then for each tracked persona, write a **full paragraph** explaining their arc. This is the most valuable section of the cross-synthesis — it turns simulated data points into human stories. The paragraph should connect their background (who they are, what they care about) to their journey across exercises (how their reactions evolved or stayed consistent), ending with what archetype they represent. Example: "Greg Thompson (#9) was enthusiastic about the core concept but hostile to passive monitoring. Across 5 exercises, he consistently valued transparency and control — any feature that removed human oversight was rejected. He represents the 'power user who wants AI as a tool, not a replacement' archetype."

Write at least 5 full-paragraph persona narratives. These are the stories that make the research memorable.

Select personas by:
- Strongest advocates (across exercises, not just one)
- Strongest critics
- Most internally contradictory (positive in one exercise, negative in another)
- Most narratively interesting (their arc tells a story)
- Representing each major segment

### 6. Strategic Recommendations

Based on ALL exercises together, what should the company do? Be specific:
- **Build first**: Which features/options/approaches were validated across exercises?
- **Avoid or defer**: What was consistently rejected or low-confidence?
- **Segment targeting**: Which personas/segments should be targeted first, based on cross-exercise enthusiasm?
- **Messaging strategy**: What language and framing resonated across exercises?
- **Risk watch list**: What could go wrong, based on the counterarguments from individual exercises?

### 7. Confidence Assessment

Rate overall study confidence:
- **Findings that are robust** (appear across multiple exercises, multiple segments, survive counterarguments)
- **Findings that are fragile** (appear in one exercise, one segment, or depend on marginal personas)
- **What real-user validation is most needed** (rank by priority)

### 8. Recommended Next Exercises

Based on what this study tested and what it revealed, what exercises should be run next? Consider:

- **Gaps in coverage**: What aspects of the product were NOT tested? (e.g., if you tested features and trust but not pricing or onboarding, recommend those)
- **Follow-up questions**: What new questions did the findings raise? Design exercises to answer them.
- **Validation priorities**: Which fragile findings would benefit from a differently-framed exercise?

For each recommendation:
- **Exercise name and study type**
- **What it would test** (1-2 sentences)
- **Why this study's findings call for it** (which specific finding or gap motivates it)
- **Expected persona coverage**: Can you reuse the same personas, or does this need a different population?

Recommend 2-4 exercises. Be specific enough that someone could write the exercise config from your description.

### 9. Cross-Exercise Artifacts

Synthesize the most actionable deliverables from across all exercise artifacts files:

- **The single best positioning statement** (drawing from copy artifacts, concept reactions, and competitive findings)
- **Top 5 objections and responses** (deduplicated and ranked across exercises)
- **Segment-specific go-to-market angles** (one sentence per segment, informed by all exercises)
- **The referral stories that survived multiple exercises** (which word-of-mouth narratives are consistent?)

This section should contain things a marketing or product team can use immediately.

### 10. Study Limitations

- Note the total persona count and segment coverage
- Flag any segments or demographics that are underrepresented
- Note any exercises where the synthesis flagged sycophancy or variance compression
- State clearly: "These are directional hypotheses for validation with real users, not confirmed research findings."

---

## Quality Standards

- Name specific personas. "Several personas felt..." is banned. "Greg Thompson (#9), Maria Chen (#14), and Omar Haddad (#48) all..." is required.
- Quote from the per-exercise syntheses when possible. The individual exercises already did deep analysis — build on it, don't redo it.
- Cross-exercise connections are the value. If you're just summarizing each exercise, you've failed. The insight is in the CONNECTIONS between exercises.
- Contradictions are findings, not problems. Report them with curiosity, not discomfort.
- The executive summary must be actionable. "Results were mixed" is not a finding. "Build X, skip Y, validate Z with real users" is a finding.
