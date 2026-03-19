# Calibration Data Manifest

Place this file as `manifest.md` at the root of your calibration data directory. It tells Facet which files to prioritize and what each contains.

## Format

List each file (or subdirectory) with its purpose and relevance:

```
## Files

### survey-results.csv
- **Type**: Quantitative survey (N=247)
- **Contains**: Willingness-to-pay ranges, feature importance rankings, current tool usage, satisfaction scores
- **Best for**: Segment design, pricing thresholds, persona income/spending calibration

### interviews/
- **Type**: User interview transcripts (12 interviews, 30-60 min each)
- **Contains**: Verbatim quotes, discovery stories, objections, switching triggers
- **Best for**: Persona voice/vocabulary, discovery channels, deal-breaker identification

### support-tickets.md
- **Type**: Aggregated customer support themes (last 90 days)
- **Contains**: Common complaints, feature requests, confusion points
- **Best for**: Pain points, friction modeling, churn risk factors

### analytics-summary.md
- **Type**: Product usage analytics export
- **Contains**: Feature adoption rates, session frequency, retention curves, conversion funnel
- **Best for**: Usage pattern calibration, 12-month projection grounding

### competitor-landscape.md
- **Type**: Competitive analysis notes
- **Contains**: Pricing comparisons, feature matrices, positioning differences
- **Best for**: Reference point calibration, status quo alternatives
```

## Tips

- You don't need every type of data. Even a single interview transcript meaningfully improves persona quality.
- Survey data is most useful for the **plan** phase (segment design, attribute distributions).
- Interview transcripts are most useful for the **persona generation** phase (voice, vocabulary, specific details).
- Analytics data is most useful for grounding **simulation** projections in real usage patterns.
- Files can be in any text format: `.md`, `.csv`, `.txt`, `.json`, `.yaml`.
