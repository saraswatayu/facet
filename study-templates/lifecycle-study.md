---
segments: 8
personas_per_segment: 5
studies:
  - config: studies/onboarding.md
  - config: studies/features.md
  - config: studies/pricing.md
  - config: studies/retention.md
---

# Product: [Your Product Name]

[Full product description. This is the most comprehensive study type: it tests the entire user lifecycle from first impression through long-term retention. Provide maximum detail about the product, market, and competitive context.]

## Key Product Details

- Pricing: [tiers and pricing model]
- Core experience: [what using the product feels like day-to-day]
- Onboarding: [current signup-to-value flow]
- Retention: [current retention rate if known, key churn reasons]
- Target market: [primary and secondary audiences]
- Competitive landscape: [alternatives and their strengths/weaknesses]

---

## Study Goal

Full product audit. Test onboarding, feature importance, pricing, and retention with the same personas to understand the complete user lifecycle. The cross-synthesis will reveal how early experiences (onboarding) predict later behavior (retention).

## Exercise Configs (create these files)

### studies/onboarding.md
```yaml
---
study_name: onboarding
study_type: onboarding
options:
  - name: "[Flow A]"
    description: "[Onboarding approach]"
  - name: "[Flow B]"
    description: "[Onboarding approach]"
---
[Your onboarding challenge and what you want to learn]
```

### studies/features.md
```yaml
---
study_name: features
study_type: features
options:
  - name: "[Feature 1]"
    description: "[Description]"
  - name: "[Feature 2]"
    description: "[Description]"
  - name: "[Feature 3]"
    description: "[Description]"
---
[Which features matter most and why]
```

### studies/pricing.md
```yaml
---
study_name: pricing
study_type: pricing
options:
  - name: "[Model A]"
    description: "[Details]"
  - name: "[Model B]"
    description: "[Details]"
---
[Your pricing question]
```

### studies/retention.md
```yaml
---
study_name: retention
study_type: retention
options:
  - name: "[Strategy A]"
    description: "[Retention approach]"
  - name: "[Strategy B]"
    description: "[Retention approach]"
---
[What you want to learn about long-term engagement]
```
