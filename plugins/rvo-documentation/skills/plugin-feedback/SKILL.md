---
name: plugin-feedback
description: Triage feedback after an externally maintained skill, agent, or MCP run and produce a safe, copy-ready issue template for its maintainer.
---

# Plugin feedback

Turn an execution experience into evidence-based feedback without blaming the user
or defending the plugin.

## 1. Capture the experience

Record:

- plugin name, type, version, and source if available;
- the user's goal and expected behavior;
- actual behavior, relevant inputs/outputs/errors, impact, and reproducibility;
- maintainer contact or repository, if explicitly known.

Ask only for material missing details. Never request credentials, tokens, private
keys, personal data, or unnecessary full logs. Redact secrets and identifying data.

Resolve provenance only from explicit runtime or installation metadata. Do not infer
an upstream repository from the plugin name, maintainer, marketplace owner, local
copy, current working directory, or `git remote -v` of the user's project. If no
source is exposed, ask the user for it or mark the destination unknown.

**Done when:** intended and observed outcomes are distinct and the provenance is
verified or explicitly unknown.

## 2. Classify the result

Use the evidence to classify it as:

- **User/environment error:** A documented prerequisite, input, permission,
  configuration, or environment constraint was unmet. Explain the correction.
- **Expectation mismatch or product gap:** The behavior may be by design, but a
  reasonable workflow or outcome was not supported.
- **Probable defect/regression:** Documented behavior or a prior working result was
  contradicted. Capture minimal reproduction steps.
- **Insufficient evidence:** State what is unknown and request the smallest useful
  observation.

Treat confusing instructions, misleading errors, and difficult setup as usability
feedback; do not call something a user error merely because the plugin failed.

## 3. Write the issue template

Write the template in the user's language and omit empty sections:

```markdown
## Summary

## Plugin
- Name/type:
- Version/source:

## Intended outcome

## Observed outcome

## Reproduction

## Suggested improvement
```

Keep expectation mismatches and product gaps distinct from bugs. Preserve exact,
redacted error messages for probable defects. Do not invent facts.

## 4. Output only

Present the result as a concise, copy-ready GitHub issue. Include a repository or
issue-tracker link only when it is explicit in trustworthy plugin provenance;
otherwise state that the destination is unknown.

This skill is **report-only**: do not create issues, call GitHub APIs or commands,
send email, or contact the maintainer. The user copies and submits the template.
