---
segments: 6
personas_per_segment: 5
exercises:
  - config: studies/positioning-variants.md
  - config: studies/feature-differentiation.md
---

# Product: [Your Product Name]

[Describe your product AND your competitors. Be honest about where you win and where you lose. The simulation quality depends on realistic competitive context.]

## Key Product Details

- Your product: [what you do, pricing, key differentiators]
- Competitor A: [what they do, pricing, strengths]
- Competitor B: [what they do, pricing, strengths]
- Market context: [trends, shifts, why now]

---

## Study Goal

Answer: "Where do we fit?" Test positioning/messaging variants and feature differentiation to find the angles that resonate with each segment.

## Exercise Configs (create these files)

### studies/positioning-variants.md
```yaml
---
exercise_name: positioning-variants
study_type: copy
options:
  - name: "[Positioning A, e.g., Speed]"
    description: "[Headline + subheadline + value prop framing speed]"
  - name: "[Positioning B, e.g., Simplicity]"
    description: "[Headline + subheadline + value prop framing simplicity]"
  - name: "[Positioning C, e.g., Value]"
    description: "[Headline + subheadline + value prop framing value]"
---
[Context about your positioning challenge]
```

### studies/feature-differentiation.md
```yaml
---
exercise_name: feature-differentiation
study_type: features
options:
  - name: "[Your Unique Feature]"
    description: "[What it does, why competitors don't have it]"
  - name: "[Table Stakes Feature]"
    description: "[What it does, how yours compares]"
  - name: "[Competitor Advantage]"
    description: "[Feature competitors have that you don't]"
---
[Context about feature comparison and what you want to learn]
```
