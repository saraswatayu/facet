---
segments: 6
personas_per_segment: 5
studies:
  - config: studies/concept-reactions.md
  - config: studies/feature-importance.md
  - config: studies/pricing-sensitivity.md
---

# Product: [Your Product Name]

[Describe your product in 2-3 paragraphs. Include: what it does, who it's for, how it works, what it costs, and what makes it different from alternatives.]

## Key Product Details

- Pricing: [tiers, pricing model]
- Core experience: [what using the product feels like]
- Target market: [who you're building for]
- Competitive landscape: [what alternatives exist]

---

## Study Goal

Answer: "Should we launch this?" Test concept reactions, feature importance, and pricing sensitivity with the same personas to get a unified picture of product-market fit.

## Study Configs (create these files)

### studies/concept-reactions.md
```yaml
---
study_name: concept-reactions
study_type: custom
options:
  - name: "Core Product"
    description: "[Your core value proposition]"
  - name: "Key Differentiator"
    description: "[What makes you different from alternatives]"
---
[Describe what you want to learn about how people react to your concept]
```

### studies/feature-importance.md
```yaml
---
study_name: feature-importance
study_type: features
options:
  - name: "[Feature 1]"
    description: "[What it does]"
  - name: "[Feature 2]"
    description: "[What it does]"
  - name: "[Feature 3]"
    description: "[What it does]"
---
[Context about these features and what you want to learn]
```

### studies/pricing-sensitivity.md
```yaml
---
study_name: pricing-sensitivity
study_type: pricing
options:
  - name: "[Pricing Model A]"
    description: "[Details]"
  - name: "[Pricing Model B]"
    description: "[Details]"
---
[Context about your pricing options]
```
