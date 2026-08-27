---
name: traceability
description: Keeps requirements bi-directionally traceable to code, architecture docs, and tests. Use whenever the user creates or edits code, architecture documentation, or tests that implement or verify a requirement, whenever a requirements source (requirements management tool or in-repo requirements doc) is read, or whenever the agent encounters code/docs/tests that plausibly realize a requirement but carry no reference to it. Also use when asked to check, report on, or clean up traceability/coverage between requirements and the codebase.
---

# Traceability

Every change to code, architecture documentation, or tests can be traced back to the requirement that drove it, and every requirement can be traced forward to what realizes and verifies it. The goal: nobody can silently drop a requirement, and nobody can silently touch code/docs that quietly carry requirement weight without knowing it.

## Convention lookup (do this first, every time)

The reference ID format and where requirements live are **project-specific** — never assume or invent one. Before doing anything else in this skill:

1. Check the project's `AGENTS.md` (or equivalent root instructions file) for a documented traceability convention: the ID format (e.g. `REQ-123`, `US-42`), where markers go (comment, docstring, commit trailer, test annotation), and where requirements are authored (a requirements management tool, an in-repo requirements doc, issue tracker).
2. If `AGENTS.md` documents a convention, use it exactly as written — don't "improve" the format.
3. If no convention is documented, don't guess and don't silently pick a default: tell the user no traceability convention was found and ask them to define one (format + requirement source), then offer to record their answer in `AGENTS.md` so this lookup is a one-time cost for the project.

Re-check this whenever you switch projects/repos — a convention from one project must never leak into another.

## Forward tracing — writing requirement references

Whenever you create or meaningfully edit code, an architecture document, or a test that implements, expands, or verifies a specific requirement, write that requirement's ID into the change using the project's convention, right at the point it belongs (the function/class/section/test-case level, not just once per file). This is forward traceability: requirement → realization → verification.

If a single change serves more than one requirement, reference all of them, not just the first one found.

## Backward tracing — catching missing references

Whenever you read a requirements source (the requirements management tool, or an in-repo requirements doc) as part of research, and separately encounter code, architecture documentation, or a test that plausibly realizes or verifies one of those requirements but carries no reference to it, treat this as a finding, not a thing to silently fix:

- Report the gap: which file/section/test, which requirement you suspect it maps to, and why.
- Propose adding the reference using the project's convention.
- Don't insert the reference without telling the user what you inferred and why — an inferred link can be wrong, and a silent wrong link is worse than no link.

Full-text search for a requirement ID across the repo counts as a valid traceability check — a reference doesn't need a link back from the requirement side to count as bi-directional. Bi-directional here means both directions of the check get performed (forward: does this requirement have a realization/verification anywhere; backward: does this code/doc/test map to a requirement), not that both sides physically embed a pointer to the other.

## The two failure modes to guard against

1. **Orphan requirement** — a requirement exists and nothing in code, architecture docs, or tests references it. It was silently dropped somewhere.
2. **Orphan realization** — code, an architecture decision, or a test exists with no requirement reference at all, and no one can say why it's there. Common causes: scope creep, speculative "just in case" work, or leftover structure from a requirement that was later removed without cleanup.

A traceability check (whether requested directly or done as part of research) must check for both, not just confirm that some references exist somewhere.

## Reporting a traceability check

When asked to check or report on traceability (rather than just writing a reference while creating something), produce a short, concrete report:

- **Orphan requirements**: requirement ID + description, and where you looked for a realization/verification and found none.
- **Orphan realizations**: file/section/test + what it appears to do, and why it looks like it should map to a requirement but doesn't.
- **Confirmed links**: only worth listing if the user asked for full coverage, not a gap report — don't pad a gap-focused report with everything that's already fine.

Don't claim full coverage unless you actually searched every requirement and every plausible realization location — say explicitly if the check was partial (e.g. only one directory, only one requirement category).
