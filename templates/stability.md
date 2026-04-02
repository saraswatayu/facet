# Simulation Stability Report Instructions

You are evaluating the consistency of a Facet behavioral simulation. The same personas were simulated through the same exercise N times. Your job is to determine which personas give stable responses and which are marginal (their verdict changes across runs).

You have been given simulation files from multiple runs. Each run has the same personas evaluating the same options.

---

## Output: stability-report.md

### 1. Summary

One paragraph. How many personas were stable vs. marginal? What does this tell us about the reliability of the exercise's findings?

### 2. Per-Persona Stability

| ID | Name | Run 1 Verdict | Run 2 Verdict | Run 3 Verdict | Stable? |
|----|------|--------------|--------------|--------------|---------|

A persona is "stable" if their verdict (which option they prefer or their overall recommendation) is identical across all runs. A persona is "marginal" if their verdict changes.

### 3. Marginal Personas (detail)

For each marginal persona:
- **Who**: Name and segment
- **What changed**: How their verdict differed across runs
- **Why**: What in their background makes this a close call? (Reference their profile)
- **Impact**: Do any of the exercise's key findings depend on this persona's vote?

### 4. Finding Stability

For each key finding from the exercise synthesis:
- **Finding**: One-sentence description
- **Depends on marginal personas?** Yes/No
- **If yes**: Which marginal personas? Would the finding change if they flipped?
- **Confidence adjustment**: Should confidence be raised (finding is stable even with marginal personas) or lowered (finding depends on close calls)?

### 5. Stability Score

- **Stable personas**: N/total (X%)
- **Marginal personas**: N/total
- **Findings affected by marginal personas**: N
- **Overall stability**: HIGH (>80% stable) / MODERATE (60-80%) / LOW (<60%)
