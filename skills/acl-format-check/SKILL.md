---
name: acl-format-check
description: Check paper compliance with ACL submission formatting requirements. Use before submitting to catch formatting violations that would trigger desk rejection.
allowed-tools: Read, Grep, Glob, Bash
---

# ACL Format Compliance Check

Verify the paper meets ACL submission requirements. A formatting violation can mean desk rejection regardless of paper quality.

## Structural Requirements

Check that these sections exist (in order):
- [ ] Abstract (within `\begin{abstract}`)
- [ ] Introduction
- [ ] Related Work (can be titled "Background" or placed before or after methods)
- [ ] Methodology / Approach / Method
- [ ] Experiments / Evaluation
- [ ] Results (can be merged with Experiments)
- [ ] Conclusion
- [ ] Limitations section (REQUIRED for ACL 2024+, does NOT count toward page limit)
- [ ] Ethics Statement (if applicable, does NOT count toward page limit)

## Page Limits

Compile the paper and count pages:
- **Long paper**: 8 pages content + unlimited references + limitations + ethics
- **Short paper**: 4 pages content + unlimited references + limitations + ethics
- Appendices: check if the venue allows them (ACL main does, some workshops don't)

Report: "Paper is N pages of content (limit: 8). References start on page N."

## Anonymization

Search for violations:
```bash
# Author names or affiliations in the text
grep -rni 'university of\|institute of\|@.*\.edu\|@.*\.ac\.' paper/*.tex

# Self-citations that break anonymity
grep -rni 'our previous work\|our prior\|we previously\|in \[our\|in our earlier' paper/*.tex

# URLs containing identifying info
grep -rnoE 'github\.com/[^ }]+|gitlab\.com/[^ }]+|huggingface\.co/[^ }]+' paper/*.tex

# Check \author{} is anonymized
grep -n '\\author' paper/*.tex
```

**CRITICAL violations:**
- Author names visible in `\author{}`
- GitHub/lab URLs in the paper body
- "Our previous work [X]" where [X] is self-citation
- Acknowledgments section present (should be removed for review)

## Typography & Formatting

- [ ] Uses the correct style file (acl2025.sty, or appropriate year)
- [ ] `\aclfinalcopy` is NOT set (for submission; should be set for camera-ready)
- [ ] Font: Times New Roman or similar serif (check style file handles this)
- [ ] Two-column format
- [ ] Figures and tables don't overflow column width
- [ ] No manual page breaks or column breaks that could break with edits
- [ ] Captions below figures, above tables (ACL convention)

## Citations & References

- [ ] Uses `\citep{}` and `\citet{}` correctly (natbib)
- [ ] No bare `\cite{}` — ACL style requires parenthetical vs textual distinction
- [ ] References are complete (no "et al." in the bib entry, include all authors)
- [ ] Conference/journal references include year, venue, pages
- [ ] ArXiv preprints: include arXiv ID, note if published version exists
- [ ] No duplicate bib entries (same paper, different keys)
- [ ] Bib entries have consistent formatting

## Common Desk-Rejection Issues

- [ ] Paper compiles without errors
- [ ] No "??" in the PDF (undefined references)
- [ ] PDF is within file size limits (typically 10-20MB)
- [ ] Fonts are embedded in the PDF: `pdffonts output.pdf` should show all embedded
- [ ] No colored hyperlinks visible (some styles show blue links — check `\hypersetup`)

## Output

```
ACL FORMAT CHECK
================
Style: acl2025 ✅
Pages: 7/8 ✅
Anonymized: ❌ Found "github.com/username/repo" on line 234
Sections: ✅ All required sections present
  ⚠️  Missing: Limitations section (REQUIRED)
Citations: ✅ 
  ⚠️  3 uses of bare \cite{} — should be \citet{} or \citep{}
References: 
  ❌ 2 entries missing venue/year
  ⚠️  1 apparent duplicate: "smith2023" and "smith2023a" cite same paper
Compilation: ✅ No errors, 2 warnings (minor overfull hboxes)

MUST FIX BEFORE SUBMISSION:
1. Remove GitHub URL from line 234
2. Add Limitations section
3. Complete bib entries for [keys]
```
