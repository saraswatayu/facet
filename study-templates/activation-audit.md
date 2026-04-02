---
segments: 6
personas_per_segment: 5
studies:
  - config: studies/onboarding-flows.md
  - config: studies/feature-discovery.md
---

# Product: [Your Product Name]

[Describe your product with emphasis on the first-time user experience. What does a new user see? What do they need to do before getting value? What's the "aha moment"?]

## Key Product Details

- Signup flow: [what's required to start]
- Time to value: [how long until a user gets real value]
- Current activation rate: [if known]
- Common drop-off points: [if known]
- Competitive onboarding: [how alternatives handle this]

---

## Study Goal

Answer: "How should we onboard users?" Test 2-3 onboarding flows and feature discovery approaches. Identify where personas drop off and what creates psychological ownership.

## Exercise Configs (create these files)

### studies/onboarding-flows.md
```yaml
---
study_name: onboarding-flows
study_type: onboarding
options:
  - name: "[Flow A]"
    description: "[Step-by-step description of the onboarding experience]"
  - name: "[Flow B]"
    description: "[Step-by-step description]"
  - name: "[Flow C]"
    description: "[Step-by-step description]"
---
[Context about your activation challenge and what you want to learn]
```

### studies/feature-discovery.md
```yaml
---
study_name: feature-discovery
study_type: features
options:
  - name: "[Core Feature]"
    description: "[What it does, how users find it]"
  - name: "[Secondary Feature]"
    description: "[What it does, how users find it]"
  - name: "[Power Feature]"
    description: "[What it does, how users find it]"
---
[Context about feature discovery in the context of new users]
```
