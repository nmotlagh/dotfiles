---
name: compile-latex
description: Compile a LaTeX paper and report errors, warnings, and output summary. Use when .tex files are modified or when the user asks to build/compile the paper.
allowed-tools: Read, Bash, Grep, Glob
---

# Compile LaTeX Paper

Compile the paper and provide a structured report.

## Steps

1. **Find the build system.** Look for (in order):
   - `Makefile` in the paper directory → use `make all`
   - `latexmk` config → use `latexmk -pdf`
   - Fall back to: `pdflatex → bibtex → pdflatex → pdflatex`

2. **Run compilation** capturing all output:
   ```bash
   cd paper && make clean && make all 2>&1 | tee /tmp/latex-build.log
   ```

3. **Parse the log for issues.** Categorize as:

   **ERRORS** (compilation failed):
   - `! LaTeX Error:`
   - `! Undefined control sequence`
   - `! Missing $ inserted`
   - `! Emergency stop`
   - Report the FIRST error with 10 lines of context

   **WARNINGS** (compiled but has problems):
   - `Overfull \\hbox` — line too wide, may extend into margin
   - `Underfull \\hbox` — line too loose, bad spacing
   - `Citation .* undefined` — missing bibliography entry
   - `Reference .* undefined` — broken \ref{}
   - `Label .* multiply defined` — duplicate \label{}
   - `Font shape .* undefined` — missing font

   **INFO** (cosmetic):
   - Page count (from `Output written on *.pdf (N pages)`)
   - Number of figures and tables (grep for `\begin{figure}` and `\begin{table}`)
   - File size of output PDF

4. **Report format:**
   ```
   ✅ Compilation successful (or ❌ Compilation failed)
   
   Pages: N | Figures: N | Tables: N | PDF: N.NMB
   
   ERRORS (N):
   - file.tex:42 — description
   
   WARNINGS (N):
   - file.tex:87 — Overfull hbox (3.2pt too wide)
   - Reference `tab:foo` undefined
   
   INFO:
   - 2 overfull hboxes (minor, < 1pt)
   ```
