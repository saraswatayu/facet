# Feature Prioritization Study Simulation Rules

## Important Caveat

Feature prioritization is the WEAKEST use case for synthetic personas. Research consistently shows synthetic users "care about everything equally" and cannot effectively prioritize (NN/g, 2024). This study should produce:
- Feature REACTIONS by segment (how each segment responds to each feature)
- Potential CONCERNS and OBJECTIONS per feature
- Feature INTERACTION analysis (which must ship together, which conflict)

This study should NOT be used for:
- Definitive ranked priority lists (low reliability with synthetic personas)
- Precise willingness-to-pay per feature
- Go/no-go build decisions without real user validation

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
- **Willingness to pay**: Would they pay more for this feature? How much? (Note: treat these responses as directional, not precise)
- **Usage prediction**: How often would they use it? Daily/weekly/monthly/rarely?
- **Internal monologue**: Their reaction when they learn about this feature

### Kano Categorization

For each feature, each persona categorizes it as:
- **Must-Be**: Expected baseline. Absence causes dissatisfaction, but presence doesn't create delight. These are the price of entry.
- **Performance**: More is better, linearly. Satisfaction scales with how well these are done.
- **Attractive**: Delighter. Unexpected, provides outsized satisfaction. Absence doesn't cause dissatisfaction.
- **Indifferent**: Doesn't affect this persona's satisfaction either way.
- **Reverse**: Actually causes dissatisfaction when present (e.g., a feature that adds complexity they don't want).

Different personas WILL categorize the same feature differently. This disagreement is the signal — it reveals which features are segment-specific vs. universal.

### Feature Interaction Analysis

For feature combinations:
- Which features MUST ship together (dependencies)?
- Which features are redundant (choosing one eliminates need for the other)?
- Which features create compound value (1+1=3)?
- Which features conflict (adding one makes another less useful)?

### Forced Ranking

Each persona produces a forced ranking:
1. "If you could only have ONE of these features, which would it be?"
2. "Which feature would make you switch from a competitor?"
3. "Which feature would you NEVER use?"
4. Stack rank all features from most to least important

**Caveat**: Acknowledge that forced rankings from synthetic personas have low reliability. Real users prioritize based on lived experience; synthetic personas tend to rationalize rankings from feature descriptions. Treat these rankings as hypothesis-generating, not definitive.

### Aggregate Analysis

In the synthesis:
- Feature importance heatmap by segment
- Kano categorization heatmap by segment (the primary analytical tool)
- "Must build" features (consistently Must-Be or Performance across segments)
- "Segment-specific" features (high importance in specific segments only)
- "Skip" features (consistently Indifferent across segments)
- Recommended MVP feature set vs. full feature set
- Feature-driven segment targeting (which features attract which segments)
