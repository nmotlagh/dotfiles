---
name: check-tables
description: Verify numerical consistency between LaTeX tables and the prose that references them. Critical for papers with many result tables.
allowed-tools: Read, Grep, Glob, Bash
---

# Table-Text Consistency Checker

Systematically verify that every number in the paper's prose matches its source table.

## Step 1: Extract Tables

For each `\begin{table}` ... `\end{table}` environment:
1. Record the table label (from `\label{}`)
2. Record the caption text
3. Extract all numerical values and their column/row context
4. Note the table's position in the document

## Step 2: Find Prose References

For each table label, find every `\ref{tab:...}` and read the surrounding paragraph.
Also search for numbers that appear in both a table and nearby prose without explicit `\ref`.

## Step 3: Cross-Check

For each number mentioned in prose that relates to a table:

**CRITICAL mismatches:**
- Number in text differs from number in table (e.g., text says "23.0%" but table has "22.8%")
- Claimed improvement doesn't match actual difference (e.g., "improves by 3.2%" but 85.1 - 82.4 = 2.7)
- Superlatives that are wrong ("best performance" but another row is higher)
- Ranking claims that are wrong ("second-best" but it's actually third)

**WARNING:**
- Number appears in text but no table reference nearby
- Table referenced but no specific numbers discussed (might be fine, might be lazy)
- Rounding inconsistency (table has 82.37, text says 82.4 in one place and 82.37 in another)
- Different decimal precision for same metric across tables

**INFO:**
- Tables that are never referenced in text (orphaned tables)
- Very large tables where automated checking may miss context

## Step 4: Validate Computed Values

If tables contain values that are computed from other values:
- Averages: verify they match the individual values
- Deltas/improvements: verify subtraction is correct
- Percentages: verify they sum appropriately (to 100% where expected)
- Bold/underline: verify "best" markers match actual best values

## Output Format

```
TABLE CONSISTENCY REPORT
========================

Table 1 (tab:main_results) — "Main Results"
  ✅ Line 142: "82.3% accuracy" matches Table 1, row 3, col "Acc"
  ❌ Line 148: "improves by 3.2% over baseline" — actual difference is 2.7%
     Table value: 82.3, Baseline: 79.6, Difference: 2.7 (not 3.2)
  ⚠️  Line 155: "best performance on SQuAD" — Table 1 shows row 5 is higher

Table 2 (tab:ablation) — "Ablation Study"
  ✅ All 4 referenced numbers match
  ⚠️  Table 2 is never referenced in the text

Summary: N tables, N numbers checked, N critical, N warnings
```
