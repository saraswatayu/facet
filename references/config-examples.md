# Config Examples

Reference configs for generate_config.py. These show the exact YAML format that
parse_config.py expects.

## Product Config (for sim.sh init)

```yaml
---
segments: 6
personas_per_segment: 8
---

# Product: TaskFlow

TaskFlow is a task management app for freelancers. Core features: project boards,
time tracking, invoicing, and client portals. $15/month basic, $30/month pro.

## Key Product Details

- $15/month Basic: project boards, time tracking, basic invoicing
- $30/month Pro: everything in Basic + client portals, recurring invoices, integrations
- Web app + iOS/Android
- Target: solo freelancers and small agencies (2-5 people)
- Competitors: Notion ($10/mo), Todoist ($5/mo), Monday.com ($12/seat/mo)
```

## Study Config (for sim.sh study)

### Pricing study

```yaml
---
study_name: pricing-tiers
study_type: pricing
options:
  - name: "Basic Plan"
    description: "$15/month — project boards, time tracking, basic invoicing"
  - name: "Pro Plan"
    description: "$30/month — everything in Basic + client portals, recurring invoices, integrations"
  - name: "Single Tier"
    description: "$22/month flat — all features, no tier distinction"
---

## Options to Test

### Basic Plan: $15/month
Core freelancer tools. Project boards, time tracking, basic invoicing.
Positioned as the affordable entry point for solo freelancers.

### Pro Plan: $30/month
Full suite. Client portals, recurring invoices, Zapier/Slack integrations.
Positioned for freelancers with 5+ clients or small agencies.

### Single Tier: $22/month flat
Every feature, one price. No decision fatigue. The Superhuman model.
Risk: leaves money on the table from users who'd pay $30.
```

### Features study

```yaml
---
study_name: ai-features
study_type: features
options:
  - name: "AI Time Estimates"
    description: "Predicts how long tasks will take based on past projects"
  - name: "Smart Invoicing"
    description: "Auto-generates invoices from tracked time with one click"
  - name: "Client Insights"
    description: "Dashboard showing which clients are most profitable"
---

## Features to Evaluate

### AI Time Estimates
Uses historical project data to predict task duration. Shows confidence
intervals. Helps freelancers quote more accurately.

### Smart Invoicing
One-click invoice generation from tracked time. Matches line items to
projects. Sends reminders automatically.

### Client Insights
Profitability dashboard: revenue per client, average hourly rate,
payment speed. Helps freelancers focus on high-value relationships.
```

## Study Config (for sim.sh study)

```yaml
---
segments: 6
personas_per_segment: 8
studies:
  - config: studies/taskflow-pricing.md
  - config: studies/taskflow-features.md
---

# Product: TaskFlow

TaskFlow is a task management app for freelancers...
(full product description here — doubles as product config for init)
```

## Required Fields

| Config type | Required frontmatter fields |
|------------|---------------------------|
| Product | `segments`, `personas_per_segment` |
| Study | `study_name`, `study_type`, `options` (array of name+description) |
| Study | `segments`, `personas_per_segment`, `studies` (array of config paths) |
