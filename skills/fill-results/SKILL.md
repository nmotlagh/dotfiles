---
name: fill-results
description: Update paper tables with new experimental results from output files. Use when experiments complete and results need to flow into the paper.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# Fill Results Into Paper Tables

Update paper tables with new experimental results. Argument: path to results file or directory.

Source: $ARGUMENTS

## Step 1: Understand the Results

Read the results file(s). Determine the format:
- JSON with metrics per dataset/config
- CSV/TSV with rows of results
- Log files with metrics printed at end
- Python pickle/numpy (extract via script)

Extract all metric values and their associated conditions (dataset, model variant, budget level, etc.).

## Step 2: Map Results to Tables

For each table in the paper:
1. Read the table structure (columns, rows, what each cell represents)
2. Match result metrics to table cells by:
   - Dataset name
   - Model/method variant
   - Metric name (accuracy, F1, exact match, etc.)
   - Budget/intervention level
3. Identify which cells have new values vs. which should keep existing values

## Step 3: Update Tables

For each cell that has a new value:
1. Compare with existing value (if any)
2. If the cell currently has a placeholder (---, TBD, ???), replace with new value
3. If the cell has an old value, replace it
4. Match the decimal precision of surrounding cells
5. Update any bold/underline formatting:
   - Bold = best in column (recompute after updating)
   - Underline = second-best (recompute after updating)

## Step 4: Update Prose

Search for prose that references updated numbers:
1. Find paragraphs near `\ref{tab:...}` for each updated table
2. Check if any numbers in prose now need updating
3. Check if superlatives ("best", "highest", "outperforms") are still correct
4. Check if improvement claims ("+3.2%", "by a margin of") need recalculation

**IMPORTANT:** Do not silently change prose numbers. For each prose number that needs updating, show the old and new value and ask for confirmation before editing.

## Step 5: Verification

After all updates:
1. Compile the paper (invoke compile-latex skill if available)
2. Run check-tables to verify consistency
3. Report summary:

```
RESULTS UPDATE SUMMARY
======================
Source: [results file path]
Tables updated: N
Cells updated: N (of which N were placeholders, N were value changes)

Changes:
  tab:main_results — 12 cells updated, 3 bold markers moved
  tab:ablation — 4 cells updated (were TBD)
  
Prose updates needed:
  Line 142: "82.3%" → should be "84.1%" (awaiting confirmation)
  Line 148: "improves by 3.2%" → should be "improves by 4.5%"

Remaining placeholders: N cells still have TBD/--- values
```
