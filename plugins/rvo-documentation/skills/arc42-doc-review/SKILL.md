---
name: arc42-doc-review
description: Reviews arc42 architecture documentation (AsciiDoc/.adoc) and gives concrete, prioritized suggestions to make it shorter, more precise, and diagram-first. Use this any time the user shares or references an .adoc architecture chapter/subchapter, an arc42 section, a cross-cutting concept, or asks for feedback, review, or a quality check on architecture documentation — even if they don't say "arc42" explicitly. Also use when the user wants to know if a chapter answers the right questions, has too much prose, or is missing diagrams, or wants a rewritten/shortened draft of a specific section. Triggers on requests like "review this chapter", "is this building block view any good", "check my cross-cutting concept doc", "this arc42 section feels bloated".
user-invocable: true
disable-model-invocation: true
---

# arc42 Documentation Review

Reviews scoped arc42 chapters/subchapters (single files or excerpts, in AsciiDoc) for a team that values **short, precise, diagram-first** documentation over prose. The team is 4 architects each writing different (and sometimes overlapping) chapters — so cross-chapter consistency and "did this chapter actually answer its questions" matter as much as writing quality.

Read `references/arc42-chapters.md` before reviewing anything — it defines, per arc42 chapter, the intention, the questions it must answer, the diagrams expected, and common smells. The review is only as good as this mapping, so don't skip it, and don't rely on generic "good documentation" instincts instead of it. The Traceability lens (step 2E) uses the `traceability` skill's bi-directional concept, mapped here onto arc42's specific chapter chain.

## Workflow

### 1. Identify scope and intent

Figure out which arc42 chapter/subchapter(s) the input belongs to, using the priority order in `references/arc42-chapters.md` (filename → headers/anchors → content shape).

**If it's genuinely ambiguous, stop and ask** — don't guess. Ask two things together:
- Which arc42 chapter/subchapter is this?
- What specific question or concern was this piece meant to address? (This second question matters even when the chapter is obvious — two architects can both write "chapter 8 subchapter" content with completely different intents.)

If multiple files are given at once (e.g. reviewing several chapters, or one chapter written by two architects), note that explicitly and add a cross-chapter consistency pass (see step 4).

Diagrams referenced from the .adoc are typically PlantUML source compiled to SVG/PNG and included as images. If PlantUML source files are available alongside the .adoc, check them too — a diagram that doesn't match its own source, or a source file with no corresponding image, is worth flagging. If only the compiled image is available, review it visually (open with `view`) rather than skipping diagram review.

### 2. Review the content

Work through these five lenses. For each finding, cite the specific location (heading, paragraph, or line) — vague feedback like "could be more concise" isn't actionable for a team that already knows it wants concise docs.

**A. Intent fulfillment** — Using the chapter's "must answer" list from the reference file: which questions does this content actually answer, and which are left open? An "open question" is anything a careful reader would still have to ask the author after reading this. This is usually the highest-value finding for this team, so don't bury it.

**B. Prose-to-structure** — Flag paragraphs that are:
- Restating context/motivation already established elsewhere (ch. 1, or earlier in the same doc)
- Describing a list, comparison, or relationship in sentence form when a table/bullet list would be shorter and clearer
- Describing something structural or relational in prose ("Component X depends on Y and Z, which in turn...") when it should be a diagram

For each, name the specific replacement (e.g. "convert this paragraph to a 3-row table" or "this dependency description belongs in a component diagram, not text").

**C. Missing/weak diagrams** — Cross-check against the "Diagrams" expectation per chapter in the reference file. Missing a diagram the chapter type demands (context, building block, runtime, deployment especially) is a high-priority finding, not a nice-to-have. If a diagram exists, sanity-check: does it match what the prose claims? Is it at a sensible level of detail (not overly deep, not a black box hiding all the interesting structure)?

**D. Cross-chapter consistency** (only when reviewing multiple files, or when the user mentions other chapters exist) — Check: same components/actors referred to by the same names across chapters, no contradicting statements, no duplicated content that should live in one place and be linked instead (especially common between ch. 4/9 and between ch. 8 subchapters).

**E. Traceability** — Using the `traceability` skill's bi-directional concept, check links between this chapter and where its content should be anchored or reflected elsewhere along arc42's chapter chain (goals/requirements → decisions → building blocks/concepts → runtime/deployment → risks):
- Forward gap: a requirement/constraint/quality goal (typically ch. 1/2/10) demands something this chapter doesn't fully cover, or covers a narrower scope than what's demanded.
- Backward gap: a normative element in this chapter (a mandatory field, an ID scheme, a constraint) isn't linked back to the ADR/constraint/requirement that justifies it.
- Unreflected risk: an open point or known gap in this chapter (e.g. "TBD", "not yet decided") isn't mirrored in the risks/technical debt chapter (ch. 11).

Note explicitly if the traceability check is partial (e.g. you only had this chapter and not ch. 1/2/10/11 to check against) — don't imply full coverage you didn't actually do.

### 3. Write the report to a file, not the chat

The report is a working document the person fills in over time, not a one-shot chat message — so it's written to a markdown file (`arc42-review-<chapter-slug>.md`, e.g. `arc42-review-ch08-observability.md` inside the workspace) and shared with `present_files`. Reviewing multiple files at once still produces one file covering all of them.

Two kinds of findings need two different response mechanisms in the file:

- **Open questions** are things only the author knows — they need a free-text answer field.
- **Recommendation-type findings** (Cut/restructure, Diagrams, Traceability, Cross-chapter consistency) are proposals the author judges — they need selectable options, not a blank field, since "accept/reject/modify" is faster to fill in than prose and keeps the file scannable.

Use this structure:

```
## [Chapter N: Name] — reviewed

**Intent check**: [one line: does it do what this chapter is for]

### Open questions
1. [question the chapter should answer but doesn't]
   **Answer:** _(fill in here)_
2. ...

### Cut / restructure
1. [location] → [specific fix, e.g. "→ table" / "→ cut, duplicates ch.1" / "→ diagram"]
   - [ ] Accept as proposed
   - [ ] Modify: _(brief note)_
   - [ ] Reject / leave as is
2. ...

### Diagrams
1. Missing: [what kind, why it's needed]
   - [ ] Add as proposed
   - [ ] Modify: _(brief note)_
   - [ ] Not needed
2. Weak: [what's off about an existing one]
   - [ ] Revise as proposed
   - [ ] Modify: _(brief note)_
   - [ ] Leave as is

### Traceability
1. Forward gap: [requirement in ch. X demands more/less than this chapter covers]
   - [ ] Reconcile as proposed
   - [ ] Modify: _(brief note)_
   - [ ] Not a real gap
2. Backward gap: [normative element not linked to its ADR/constraint/requirement]
   - [ ] Link as proposed
   - [ ] Modify: _(brief note)_
   - [ ] Not a real gap
3. Unreflected risk: [open point not mirrored in ch. 11]
   - [ ] Add to chapter 11 as proposed
   - [ ] Modify: _(brief note)_
   - [ ] Not a risk

### Top priority (max 3)
1. ...
2. ...
3. ...
```

Omit any section with nothing to report — don't pad the review with "Cut/restructure: none" filler, since that's exactly the kind of noise this team is trying to eliminate from their own docs. "Top priority" stays a plain list (no checkboxes) — it's a summary of the items above, not a new decision point.

If reviewing multiple files, add one `### Cross-chapter consistency` section at the end covering all of them, using the same checkbox pattern as Cut/restructure/Traceability, rather than repeating it per file.

After writing the file, keep the chat reply short: the intent check line, the top-3-priority list, and the file itself via `present_files`. Don't repeat the full report as chat text — that's the exact duplication this change is meant to avoid. Mention briefly that the person can fill in the file, ask follow-up questions in chat about any point, or come back with the filled-in file for a revision pass.

### 4. Offer, don't push, a rewrite

End by offering to produce a rewritten draft of specific flagged sections, but don't write one unprompted — the team wants control over their own docs. If they ask for a rewrite, apply the same short/precise/diagram-first standard, and keep any PlantUML source edits in a separate code block clearly marked as a suggested `.puml` change (don't silently alter diagram source without flagging it as a proposed change).

### 5. Processing a returned, filled-in report

If the person comes back with a filled-in report (pasted text or a re-uploaded file) — either in this conversation or a fresh one — treat their answers and checkbox choices as authoritative input, not more findings to re-derive:

- For **open questions**: use the given answer to resolve that point directly. If an answer reveals something the original review got wrong (e.g. it points to an ADR the review said was missing), correct that instead of repeating the original finding.
- For **checkbox items**: only act on what was selected. "Accept as proposed" → apply the original fix as-is. "Modify" → use the note instead of the original suggestion. "Reject/Leave as is/Not needed/Not a real gap/Not a risk" → drop that item entirely, don't reintroduce it in the rewrite.
- If some items were left blank, don't block on them — proceed with what's answered and list the still-open ones briefly at the end instead of re-asking the full original question.
- Produce the rewrite/next step using this resolved input, following the same standards as step 4.

## Notes

- Don't invent arc42 rules beyond what's in the reference file — if something is genuinely a house-style judgment call (not an arc42 requirement), say so rather than presenting it as a standard.
- This team is made of architects reviewing each other's work — be direct and specific, not softened. They asked for precise, not diplomatic.
- If asked to review something that isn't in the reference file's 12 chapters (e.g. a custom appendix), use the closest matching chapter's standards and say which one you're borrowing from.