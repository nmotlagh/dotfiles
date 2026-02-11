---
name: proofread-section
description: Proofread a specific LaTeX section for grammar, clarity, and style. Invoke with the filename or section name as argument.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob
---

# Proofread LaTeX Section

Perform a careful proofreading pass on: $ARGUMENTS

## Reading Strategy

1. First read the ENTIRE section to understand the argument flow
2. Then re-read line by line for issues

## Check for These Issues

### Grammar & Mechanics
- Subject-verb agreement
- Tense consistency (methods = present, experiments = past, results = present)
- Article usage (a/an/the) — especially tricky with acronyms ("an LLM" not "a LLM")
- Comma splices and run-on sentences
- Dangling modifiers ("Using our method, the results show..." → who is using?)
- Oxford comma consistency

### Academic Writing Style
- Avoid "we can see that" — just state the observation
- Avoid "it is interesting to note" — if it's interesting, the reader will notice
- Avoid "very", "really", "quite", "rather" — use precise language
- Avoid "obviously", "clearly", "of course" — if it were obvious you wouldn't need to state it
- Passive voice: acceptable in methods ("the model was trained") but prefer active for claims
- First person: "we" is fine in ACL papers, but be consistent

### LaTeX-Specific
- Math mode for all variables, numbers that are measurements, and operators
- Proper use of `~` (non-breaking space) before \cite, \ref, etc.
- En-dash `--` for number ranges (not hyphen)
- `\eg{}`, `\ie{}`, `\cf{}` or "e.g.," "i.e.," with proper comma placement
- Quotes: use `` `` and '' '' (LaTeX backtick pairs), not unicode quotes

### Clarity & Precision
- Every acronym defined on first use
- Every symbol defined before or at first use
- Forward references are necessary (don't say "as we show in Section 5" if you can restructure)
- Paragraphs that are too long (>12 lines) or too short (1-2 sentences)
- Topic sentence: does each paragraph's first sentence preview its content?

## Output Format

Present findings as:

```
PROOFREAD: [section name]
================================

GRAMMAR (N issues):
  Line ~42: "the model are trained" → "the model is trained"
  Line ~67: Dangling modifier: "Using GRPO, the loss converges..."
            → "Using GRPO, we observe that the loss converges..."

STYLE (N issues):
  Line ~15: "It is interesting to note that" → delete, state directly
  Line ~88: "very significant improvement" → "substantial improvement" or quantify

LATEX (N issues):
  Line ~23: Missing ~ before \citep: "shown by\citep{}" → "shown by~\citep{}"
  Line ~45: Hyphen used for range: "3-5" → "3--5"

CLARITY (N issues):
  Line ~30: Acronym "CI" used but not defined until line ~78
  Line ~55: Paragraph is 18 lines — consider splitting at the "However" on line ~63

OVERALL: [brief assessment of section quality]
```

Do NOT modify any files. Report only.
