---
name: review-paper
description: Simulate a thorough ACL-style peer review of the paper. Runs parallel analysis passes and synthesizes a reviewer report. Use before submission.
context: fork
agent: task
---

# ACL Paper Review Simulation

Perform a comprehensive review of the LaTeX paper in the paper/ directory, simulating an ACL program committee reviewer.

## Phase 1: Read the Full Paper

Read every .tex file in order. Understand the complete argument before critiquing.

## Phase 2: Parallel Analysis Passes

Run these checks (as subagents where possible):

### Pass A — Novelty & Positioning
- What is the core contribution? Is it clearly stated?
- How does it differ from prior work? Is the related work section thorough?
- Are there obvious missing baselines or comparisons?
- Would an ACL reviewer find this sufficiently novel?

### Pass B — Technical Soundness
- Are the claims supported by evidence?
- Is the experimental setup described in enough detail to reproduce?
- Are the evaluation metrics appropriate for the task?
- Are statistical significance tests used where appropriate? (CIs, p-values, bootstrap)
- Do the ablations isolate the claimed contributions?
- Are there confounds the authors haven't addressed?

### Pass C — Clarity & Presentation
- Is the abstract self-contained and informative?
- Does the introduction motivate the problem effectively?
- Is the paper well-organized? Does the argument flow logically?
- Are figures and tables informative and well-designed?
- Is notation consistent and clearly defined?
- Are there sections that are too dense or too sparse?

### Pass D — Numerical Consistency
- Do numbers in the text match their source tables?
- Are percentages computed correctly from the underlying counts?
- Do reported improvements (e.g., "+3.2%") match the actual difference between numbers?
- Are baselines compared fairly (same data splits, preprocessing)?

### Pass E — ACL Compliance
- Within page limits (8 pages + unlimited references for long, 4 for short)?
- Anonymous (no author names, no self-identifying URLs, no "our previous work [1]")?
- Required sections present (Abstract, Introduction, Related Work, Methodology, Experiments, Conclusion)?
- Ethics statement if needed?
- Limitations section (required for ACL 2024+)?

## Phase 3: Synthesize Review

Format as an official ACL review:

```
OVERALL SCORE: [1-5] (1=reject, 3=borderline, 5=strong accept)
CONFIDENCE: [1-5]

SUMMARY:
[2-3 sentence summary of the paper and its contribution]

STRENGTHS:
S1. [specific strength with reference to section/table]
S2. ...
S3. ...

WEAKNESSES:
W1. [specific weakness with suggested fix]
W2. ...
W3. ...

QUESTIONS FOR AUTHORS:
Q1. ...
Q2. ...

MISSING REFERENCES:
- [Any related work the authors should cite]

MINOR ISSUES:
- [Typos, formatting, small suggestions]

RECOMMENDATION:
[Specific actionable feedback: what would move this from a 3 to a 4?]
```
