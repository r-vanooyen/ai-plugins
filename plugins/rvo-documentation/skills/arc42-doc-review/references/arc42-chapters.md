# arc42 Chapter Reference
 
For each chapter/subchapter: its **intention**, the **questions it must answer**, the **diagrams a reader expects**, and **common smells** to flag. Use this to judge whether a piece of documentation fulfills its purpose — not just whether it has words in it.
 
Cross-cutting rule for ALL chapters: a paragraph earns its place only if it answers a question the chapter is meant to answer. If it's scene-setting, motivation-restating, or "as we all know" filler, flag it as prose to cut.
 
---
 
## 1. Introduction and Goals
**Intention**: Why does this system exist, what must it do, who cares about it, and what matters most.
**Must answer**: What are the top 3-5 quality goals? Who are the stakeholders and what do they expect? What's explicitly out of scope?
**Diagrams**: Usually none required; a stakeholder table is fine. A goal doesn't need a diagram — flag if this chapter is padded with diagrams that belong elsewhere.
**Smells**: Generic goals ("high quality", "maintainability") with no ranking or measurable definition. Missing stakeholder table. Restating the whole system description here instead of in ch. 3.
 
## 2. Architecture Constraints
**Intention**: Hard boundaries the architecture must respect (organizational, technical, legal, conventions).
**Must answer**: What can't be changed, and why? Which constraints are technical vs organizational vs regulatory?
**Diagrams**: None typically.
**Smells**: Constraints that are actually just decisions (belongs in ch. 9) or requirements (belongs in ch. 10) mislabeled as "constraints."
 
## 3. System Scope and Context
**Intention**: The system as a black box — who/what it talks to.
**Must answer**: What are all external actors/systems? What crosses the boundary (data, protocol, direction)? Business context vs technical context — are both needed here?
**Diagrams**: Context diagram (UML: system boundary + external actors/systems, e.g. a component diagram at black-box level, or simple box-and-line). This chapter almost always needs a diagram — flag hard if missing.
**Smells**: A wall of prose describing interfaces that a single diagram + short table would replace. Context diagram present but interfaces list in prose duplicates what's already in the diagram — pick one representation.
 
## 4. Solution Strategy
**Intention**: The handful of fundamental decisions and strategies that shape everything else.
**Must answer**: What are the key technology choices and why? What architectural patterns were chosen and why (in one paragraph each, not a treatise)?
**Diagrams**: Rarely; if a pattern is spatial (e.g. layering, hexagonal), a small diagram helps.
**Smells**: This is the #1 place for bloat — teams write essays here. Should be short: decision + one-line rationale, repeated per major decision. If a decision needs long justification, that belongs as an ADR (ch. 9), linked from here.
 
## 5. Building Block View
**Intention**: Static decomposition — the system's components/modules and their relationships, at whatever levels of zoom matter (whitebox level 1, 2, 3...).
**Must answer**: What are the top-level building blocks and their responsibilities? For any block complex enough to need a subchapter, what's inside it?
**Diagrams**: Required at every level shown — UML component diagrams or package diagrams. This is the most diagram-dependent chapter in arc42. A building block described only in prose ("Module X handles authentication and talks to Module Y and Z") is a diagram waiting to happen — flag it.
**Smells**: Prose-only component descriptions. Diagrams that don't match the prose (stale). Going too deep (level 4+) on blocks nobody asked about. Missing responsibility statements (name + interface list but no "what does it actually do").
 
## 6. Runtime View
**Intention**: How building blocks collaborate to realize specific important scenarios (not every scenario — the important/risky/complex ones).
**Must answer**: Which scenarios were picked and why do they matter? Step by step, what happens?
**Diagrams**: Sequence diagrams, activity diagrams, or communication diagrams (UML) per scenario. A scenario walkthrough in pure prose ("first the client calls the gateway, which then...") is exactly what this chapter should never do in prose alone — flag hard.
**Smells**: Too many trivial scenarios (CRUD happy path) and missing the risky/concurrent/error-handling ones. Scenario described without reference to the building blocks from ch. 5 (inconsistent naming = red flag for cross-chapter consistency).
 
## 7. Deployment View
**Intention**: Technical infrastructure the system runs on, and how building blocks map onto it.
**Must answer**: What environments/nodes exist? What runs where? What are the infrastructure dependencies (network, hardware, cloud services)?
**Diagrams**: UML deployment diagram (nodes, artifacts, connections) is close to mandatory here. Flag hard if missing.
**Smells**: Infra listed as bullet points instead of a deployment diagram. Environment differences (dev/stage/prod) not called out when they matter.
 
## 8. Cross-cutting Concepts
**Intention**: Ideas that apply across multiple building blocks — e.g. security, logging, error handling, persistence, UI conventions, domain model. Usually has many subchapters, one per concept.
**Must answer** (per concept/subchapter): What's the concept, why is it needed, how is it implemented, where is it applied across the building blocks?
**Diagrams**: Depends on the concept. Domain model → class diagram. Security concept → maybe sequence diagram for auth flow. State-heavy concept → state diagram. If a concept involves relationships between more than 2-3 things, it wants a diagram — flag prose-only descriptions of anything relational or stateful.
**Smells**: This is where "open questions" problems show up most: a concept subchapter that describes *what* without *how*, or that never states *where* (which building blocks) it applies. Also common: concept overlaps with another subchapter's concept (duplication across cross-cutting sections) — flag for consolidation.
 
## 9. Architecture Decisions
**Intention**: Important decisions, with rationale and alternatives considered (often as ADRs).
**Must answer**: What was decided, what were the alternatives, why this one, what are the consequences/trade-offs?
**Diagrams**: Only if the decision itself is structural.
**Smells**: Decision stated without alternatives considered (reads like a fact, not a decision). Missing consequences/trade-offs — every real decision has a cost, if none is listed that's suspicious. Decisions duplicated from ch. 4 without added rationale.
 
## 10. Quality Requirements
**Intention**: Concrete, testable quality goals — expands on ch. 1's top goals into scenarios.
**Must answer**: For each quality attribute, what's the concrete scenario and the measurable acceptance criterion?
**Diagrams**: A quality tree/table is expected structure (not strictly UML but structured, not prose).
**Smells**: Vague requirements ("system should be fast") with no scenario or number attached. Requirements that don't map back to ch. 1's stated goals.
 
## 11. Risks and Technical Debt
**Intention**: Known risks and debt, honestly stated, with mitigation/plan.
**Must answer**: What's risky or already compromised? What's the impact if it bites? What's the plan (or explicit decision to accept it)?
**Diagrams**: None typically.
**Smells**: Risks listed with no mitigation or owner. Suspiciously empty section (every real system has some debt — an empty ch. 11 is itself a smell worth naming).
 
## 12. Glossary
**Intention**: Shared vocabulary, especially domain terms that differ from everyday meaning.
**Must answer**: Is every domain-specific or ambiguous term used elsewhere in the docs defined here?
**Diagrams**: None.
**Smells**: Terms used in other chapters (especially ch. 5/6/8) that aren't defined here. Glossary that only has trivial terms and misses the actually confusing ones.
 
---
 
## Identifying which chapter a scoped file belongs to
 
When given a single file or excerpt, check in this order:
1. **Filename/path** — teams often name files `05_building_blocks.adoc`, `08_concepts/03_security.adoc`, etc. Use this first if present.
2. **AsciiDoc headers/anchors** — look for `[[section-05]]`, arc42-style include structure, or a title matching one of the 12 chapter names above.
3. **Content shape** — if 1 and 2 are inconclusive, infer from what questions the content is actually trying to answer, using the "Must answer" list above.
If still ambiguous, **stop and ask the person**: which chapter/subchapter is this, and — importantly — what specific question or concern was this piece of documentation meant to address? Don't guess at intent for something this consequential; a wrong assumption here derails the whole review.