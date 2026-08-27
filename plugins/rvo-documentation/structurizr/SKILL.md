---
name: structurizr
description: Define, adjust, and maintain Structurizr DSL (*.dsl) workspaces and C4 views. Use when the user asks to create/update architecture models, fix DSL syntax/identifier issues, add containers/components/relationships, update dynamic/deployment views, refactor with archetypes/expressions, or validate/inspect a workspace.
argument-hint: "<path-or-goal> e.g. architecture/workspace.dsl: add payment context and deployment view"
user-invocable: true
disable-model-invocation: true
---

# Structurizr DSL Assistant

Use this skill to make safe, consistent edits to Structurizr DSL while preserving model integrity and view stability.

## When to use

- Creating a new DSL workspace or extending an existing one.
- Updating model elements (people, software systems, containers, components, deployment nodes).
- Updating relationships, tags, properties, or perspectives.
- Adding or maintaining views (system context, container, component, dynamic, deployment, filtered, custom).
- Refactoring large DSL files for maintainability (archetypes, expressions, `!element`, `!relationship`, `!elements`, `!relationships`).
- Troubleshooting common DSL issues (identifier scope, forward references, unstable generated view keys).

## Workflow

1. Confirm scope and target files
- Identify which `.dsl` files are in scope.
- If the request is ambiguous, ask for a target file/path and desired diagram outcomes.

2. Read before changing
- Inspect the existing `workspace`, `model`, and `views` structure.
- Identify identifier strategy (`flat` vs `!identifiers hierarchical`) and keep it consistent.
- Check if view keys are explicit; keep or introduce stable keys where appropriate.

3. Apply model changes safely
- Define elements before referencing them in relationships (no forward references).
- Reuse existing identifiers and tags; do not create near-duplicates.
- Prefer local, incremental edits instead of full rewrites.
- For common infrastructure/deployment concepts (API gateway, load balancer, Kubernetes, AWS services, microservices), check the [patterns catalog](https://docs.structurizr.com/dsl/patterns) for an established modeling convention before inventing a new one.
- When extending workspaces, use `workspace extends ...` and `!element`/`!relationship` patterns.

4. Apply view changes safely
- Keep includes/excludes aligned with view intent.
- Prefer explicit keys for long-lived views to avoid layout churn.
- For dynamic views, use existing static relationships and only override text/technology when needed.
- For deployment views, verify environment and scope alignment.

5. Refactor for maintainability when requested
- Introduce `archetypes` for repeated technology/tags/properties patterns.
- Use expressions for bulk operations where this reduces duplication.
- Use `!elements` / `!relationships` for targeted bulk updates.

6. Validate and inspect
- Run Structurizr via Docker from the repository root:
  - `docker run --rm -v "$(pwd):/usr/local/structurizr" structurizr/structurizr validate --workspace /usr/local/structurizr/<file.dsl>`
  - `docker run --rm -v "$(pwd):/usr/local/structurizr" structurizr/structurizr inspect --workspace /usr/local/structurizr/<file.dsl>`
- If validation fails, fix the root cause and re-run.

7. Report clearly
- Summarize what changed in model, views, and identifiers.
- Call out any assumptions or unresolved ambiguities.

## Guardrails and pitfalls

- No forward referencing/hoisting: define elements before use in relationships.
- `!identifiers hierarchical` affects element identifiers, not group handling.
- Auto-generated view keys are not stable; prefer explicit keys for maintained diagrams.
- Keep model canonical: avoid duplicate elements that differ only by naming.
- Avoid broad, speculative restructuring when the user asks for a focused change.

## References

- [Language reference](./references/Language reference.md)
- [Structurizr DSL: language](https://docs.structurizr.com/dsl/language)
- [Structurizr DSL: identifiers](https://docs.structurizr.com/dsl/identifiers)
- [Structurizr DSL: expressions](https://docs.structurizr.com/dsl/expressions)
- [Structurizr DSL: archetypes](https://docs.structurizr.com/dsl/archetypes)
- [Structurizr DSL: cookbooks](https://docs.structurizr.com/dsl/cookbook)
- [Structurizr DSL: patterns](https://docs.structurizr.com/dsl/patterns)
- [Structurizr DSL: FAQ](https://docs.structurizr.com/dsl/faq)
- [Structurizr CLI](https://docs.structurizr.com/cli)