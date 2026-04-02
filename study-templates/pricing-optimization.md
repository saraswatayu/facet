---
segments: 8
personas_per_segment: 5
studies:
  - config: studies/pricing-models.md
---

# Product: [Your Product Name]

[Describe your product. Focus on the value delivered, not just features. Include current pricing if applicable, and the specific pricing question you're trying to answer.]

## Key Product Details

- Current pricing: [what you charge today, or "new product"]
- Value delivered: [what users get, in concrete terms]
- Usage patterns: [how often, how much value per use]
- Competitive pricing: [what alternatives cost]

---

## Study Goal

Answer: "How should we price this?" Deep-dive into 2-3 pricing models with a large persona set. Single study, maximum depth.

## Exercise Config (create this file)

### studies/pricing-models.md
```yaml
---
study_name: pricing-models
study_type: pricing
options:
  - name: "[Model A, e.g., Flat Monthly]"
    description: "[Price point, what's included, limits]"
  - name: "[Model B, e.g., Usage-Based]"
    description: "[Price point, what's included, limits]"
  - name: "[Model C, e.g., Freemium + Premium]"
    description: "[Free tier details, premium price, upgrade triggers]"
---
[Context: why you're considering these models, what tradeoffs matter, any constraints]
```
