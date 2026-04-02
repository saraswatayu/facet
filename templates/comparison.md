# Study Comparison Instructions

You are comparing findings between two runs of a Facet behavioral simulation study. Both studies tested the same (or similar) product with different personas, different calibration data, or different configurations. Your job is to identify which findings are stable (appear in both runs) and which are fragile (appear in only one).

You have been given:
- Cross-synthesis or per-study synthesis files from Study A
- Cross-synthesis or per-study synthesis files from Study B

Read ALL provided synthesis files before writing.

---

## Output: comparison.md

Write a single document with these sections:

### 1. Comparison Summary

Two paragraphs. What are the studies being compared? How do they differ (personas, calibration, study config)? What's the headline finding from the comparison?

### 2. Stable Findings

Findings that appear in BOTH studies. For each:
- **Finding**: One-sentence description
- **Study A evidence**: How it appeared (quote or paraphrase)
- **Study B evidence**: How it appeared
- **Confidence boost**: This finding surviving two independent runs increases confidence. Rate: HIGH / MODERATE

These are the gold. They're the findings you can act on.

### 3. Fragile Findings

Findings that appear in ONLY ONE study. For each:
- **Finding**: One-sentence description
- **Which study**: A or B
- **Why it might be fragile**: Was it driven by specific personas? A narrow segment? An artifact of the simulation?
- **Validation priority**: Should this be tested with real users? HIGH / LOW

### 4. Contradictions

Findings where Study A says X and Study B says Y. For each:
- **Topic**: What they disagree about
- **Study A position**: Summary
- **Study B position**: Summary
- **Likely cause**: Different personas? Different framing? Random variation?
- **Resolution**: Which is more plausible and why, or "requires real-user validation"

### 5. Stability Score

Overall assessment:
- **Stable findings**: N out of total
- **Fragile findings**: N
- **Contradictions**: N
- **Overall stability**: HIGH (>70% stable) / MODERATE (40-70%) / LOW (<40%)
- **Recommendation**: What should the product team trust vs. validate?
