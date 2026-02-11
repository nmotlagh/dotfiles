---
name: check-refs
description: Validate all cross-references, citations, and labels in a LaTeX paper. Use when checking paper integrity or before submission.
allowed-tools: Read, Grep, Glob, Bash
---

# Check References and Citations

Systematically validate every cross-reference in the paper.

## Step 1: Collect all definitions

Scan all .tex files in the paper directory:
```bash
# All \label{} definitions
grep -rn '\\label{' paper/*.tex paper/**/*.tex 2>/dev/null

# All bibliography keys from .bib files
grep -n '^@' paper/*.bib 2>/dev/null | sed 's/@.*{//' | sed 's/,$//'
```

## Step 2: Collect all references

```bash
# All \ref{}, \cref{}, \autoref{}, \eqref{}
grep -rnoE '\\(ref|cref|autoref|eqref|Cref)\{[^}]+\}' paper/*.tex

# All \cite{}, \citet{}, \citep{}, \citeauthor{}, \citeyear{}
grep -rnoE '\\cite[tp]?\{[^}]+\}' paper/*.tex
```

## Step 3: Cross-reference validation

Check for:

**CRITICAL:**
- `\ref{}` or `\cite{}` pointing to nonexistent label/key → "Reference X undefined"
- `\label{}` defined more than once → "Multiply defined label"

**WARNING:**
- `\label{}` defined but never referenced → "Orphaned label"
- Bibliography entry never cited → "Orphaned bib entry"
- `\cite{}` with multiple keys where one is invalid → "Partially broken citation"

**STYLE:**
- Inconsistent label prefixes: all tables should be `tab:`, figures `fig:`, sections `sec:`, equations `eq:`
- Using `\ref` where `\cref` would auto-format (if cleveref is loaded)
- `\cite{}` used where `\citet{}` or `\citep{}` would be more appropriate for ACL style
- Citations in parenthetical context using `\citet` instead of `\citep`

## Step 4: Report

```
CROSS-REFERENCE REPORT
======================
Labels defined: N | Labels referenced: N | Orphaned: N
Bib entries: N | Cited: N | Uncited: N

CRITICAL (N):
- main.tex:42 — \ref{tab:nonexistent} — label not defined
- refs.bib — key "smith2023" cited but not in bibliography

WARNING (N):
- main.tex:15 — \label{fig:old_diagram} defined but never referenced

STYLE (N):
- main.tex:88 — \cite{jones2024} in running text, use \citet{} instead
- main.tex:92 — \label{results_table} should be \label{tab:results_table}
```
