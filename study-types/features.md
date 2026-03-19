# Feature Prioritization Study Simulation Rules

## What This Study Tests

A set of potential features for a product. The goal is to determine which features:
1. Matter most to which segments
2. Would drive adoption/purchase decisions
3. Are "table stakes" vs. "differentiators" vs. "nice to have"
4. Interact with each other (bundles, dependencies, conflicts)

## Simulation Framework

### Per-Persona Feature Evaluation

For each feature being tested, the persona evaluates:
- **Importance** (0-10): How much does this feature matter to their use case?
- **Excitement** (0-10): How much does this feature excite them? (Importance and excitement differ — a security feature may be important but not exciting)
- **Willingness to pay**: Would they pay more for this feature? How much?
- **Usage prediction**: How often would they use it? Daily/weekly/monthly/rarely?
- **Internal monologue**: Their reaction when they learn about this feature

### Feature Interaction Analysis

For feature combinations:
- Which features MUST ship together (dependencies)?
- Which features are redundant (choosing one eliminates need for the other)?
- Which features create compound value (1+1=3)?
- Which features conflict (adding one makes another less useful)?

### Prioritization Framework

Each persona produces a forced ranking:
1. "If you could only have ONE of these features, which would it be?"
2. "Which feature would make you switch from a competitor?"
3. "Which feature would you NEVER use?"
4. Stack rank all features from most to least important

### Aggregate Analysis

In the synthesis:
- Feature importance heatmap by segment
- "Must build" features (consistently high importance across segments)
- "Segment-specific" features (high importance in specific segments only)
- "Skip" features (consistently low importance)
- Recommended MVP feature set vs. full feature set
- Feature-driven segment targeting (which features attract which segments)
