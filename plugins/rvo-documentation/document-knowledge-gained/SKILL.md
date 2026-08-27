---
name: document-knowledge-gained
description: Use this skill when the user wants to wrap up, close out, or end a working session in a repo-backed project (e.g. "let's wrap up", "close out for today", "bye", "done for now", or explicitly invoking /document-knowledge-gained, optionally with a topic like "/document-knowledge-gained about the CI/CD" to scope it). Captures durable, project-specific knowledge that surfaced during the conversation — architecture decisions, gotchas, non-obvious behavior, naming conventions, system boundaries — and folds it into the project's existing documentation (as structured by AGENTS.md) rather than losing it when the chat ends. Always trigger this at explicit session-end signals in a git repo context, even if the user doesn't mention documentation directly — that's the whole point of the skill.
user-invocable: true
disable-model-invocation: true
---
 
# Document Knowledge Gained
 
A session-end skill: before the conversation's context disappears, decide what part of it is worth keeping, and write only that part into the project's real documentation.
 
This skill requires a git repo context (Claude Code, GitHub Copilot workspace, or similar) with file read/write access. It is not for use in a plain chat interface with no filesystem.
 
## When this triggers
 
- Explicit invocation: `/document-knowledge-gained`
- Session-ending intent: "let's wrap up", "close out for today", "bye", "I'm done for now", "let's call it here"
- Do NOT trigger on a casual "bye" with no repo context, or mid-task — this is for closing out a working session, not every goodbye.
- If the conversation produced no project-specific knowledge worth keeping, say so briefly and skip the rest of the workflow. Don't manufacture something to document just to have output.
## Optional argument: topic scope
 
The skill can be invoked with a free-text topic, e.g. `/document-knowledge-gained about the CI/CD` or `/document-knowledge-gained CI/CD`.
 
- **With an argument**: restrict Step 2's extraction to the parts of the conversation relevant to that topic. Ignore other candidate knowledge for this run entirely (it isn't rejected, just left for a future run). Everything else in the workflow (Steps 3–7) proceeds normally, but scoped to that topic only.
- **Without an argument**: consider the whole conversation, minus anything already handled in a prior run this session (see below).
### Tracking what's already been handled (this session)
 
Keep a running mental record, for the duration of the conversation, of which topics/candidates have already been through Steps 3–6 in a previous run of this skill within the same session — regardless of whether the user answered "yes" or "no" to them. This includes:
- Items written to docs (approved)
- Items explicitly declined ("no")
- Topics fully covered by a previous *scoped* run (e.g. after `/document-knowledge-gained about the CI/CD` has been run and resolved, a later unscoped run should not re-surface CI/CD candidates)
When the skill runs again **without an argument**, exclude anything matching those already-handled topics from Step 2 before proceeding. This prevents re-asking about the same ground twice in one session. New knowledge that emerged *after* the previous run (even on a previously-covered topic) is fair game again — the exclusion is about not re-litigating what was already resolved, not about permanently blacklisting a topic.
 
If you're unsure whether something was already fully handled or only partially touched on, err toward including it again rather than silently dropping it — a duplicate yes/no question is a much smaller cost than silently losing a real gap.
 
## Workflow
 
Follow these steps in order. Don't skip the contradiction check or the AGENTS.md check — they gate everything after them.
 
### Step 1 — Find or establish the documentation map
 
Look for `AGENTS.md` at the repo root. This file should tell you where different kinds of documentation live (e.g. "architecture decisions go in `docs/architecture.md`", "API contracts are documented in `docs/api/`", "known gotchas live in `docs/gotchas.md`").
 
If the repo is a monorepo with multiple `AGENTS.md` files (e.g. one per package), prefer the one closest to the code actually discussed in this session; fall back to the root `AGENTS.md` if the session touched multiple packages or nothing package-specific.
 
- **If AGENTS.md exists and describes a documentation structure**: use it as the map for Step 5. Proceed.
- **If AGENTS.md is missing, or exists but doesn't describe where documentation lives**: stop and ask the user directly, e.g. "I don't see a documentation map in AGENTS.md — where should [architecture notes / gotchas / conventions / decisions] live in this repo?" Use the `ask_user_input_v0`-style tool if available, otherwise ask in plain text.
  - Sanity-check the answer against the repo (e.g. does the path/file they named actually exist, or are they asking you to create it?). If it seems inconsistent with the actual repo layout, say so and confirm before proceeding.
  - Once confirmed, write this documentation map into `AGENTS.md` yourself (create the file if it doesn't exist) under a clear heading like `## Documentation structure`, then continue to Step 2.
### Step 2 — Extract candidate knowledge from the conversation
 
Reread the conversation (scoped per the topic argument and prior-run exclusions above, if applicable) and pull out concrete, project-specific facts that were established, decided, discovered, or corrected during the session. Prioritize things that matter regardless of who wrote the code or fixed the bug:
- Architectural decisions and the reasoning behind them
- Domain/functional behavior: what the system does from a user's or business's perspective, business rules, edge cases in requirements
- End-to-end or cross-component behavior: how pieces interact, integration contracts, non-obvious system-wide effects
- Naming conventions, module boundaries, or "why this is structured this way"
- Corrections the *user* made to Claude's understanding of the domain or architecture
**De-prioritize implementation-level self-corrections** — cases where Claude made a coding mistake (wrong API, wrong dependency, wrong annotation usage) and then fixed it during the session. These sit in a gap between "temporary bug" and "generic coding knowledge": they're specific to this codebase, but they're about Claude's own trial-and-error while writing code, not about the system's architecture or behavior. Don't surface these as candidates unless the mistake reveals something a human developer would genuinely need to know going forward (e.g. a real library-version incompatibility that will keep tripping people up) rather than just "Claude used the wrong class name and corrected it." When in doubt on this specific distinction, leave it out rather than asking — this is different from the general "unsure" guidance elsewhere in this skill, because the cost here isn't losing a gap, it's spending the user's limited 5 questions on their own AI-assistant's coding mistakes instead of on the project itself.
 
Do not invent or embellish. Only include things actually established in this conversation — if you're unsure whether something was truly confirmed or just floated as a possibility, treat it as unconfirmed and leave it out (or ask, per Step 4).
 
### Step 3 — Filter: durable vs. temporary vs. generic
 
Apply this checklist to each candidate. Keep only items that pass:
 
| Keep if... | Drop if... |
|---|---|
| Still true and useful in 3+ months | Tied to a sprint, ETA, or "current status" |
| Specific to *this* project's code/architecture/product | Generic engineering best practice Claude already knows |
| Something a new team member would need explained | A one-off task note ("we fixed bug #123 today") |
| A decision with lasting consequences (why we chose X over Y) | An in-progress plan that might still change |
| Affects architecture, domain behavior, or end-to-end/user-facing behavior | Claude used the wrong API/dependency/annotation while coding and then corrected itself, with no broader lesson beyond "don't do that" |
 
When a candidate could go either way — it's project-specific and durable, but it's really about an implementation detail Claude got wrong rather than architecture or domain behavior — weight it toward dropping. This skill's priority is architecture and functional/domain knowledge; implementation trivia from Claude's own coding process is a low-value use of the user's attention even when technically durable.
 
When genuinely unsure whether something clears the bar, don't drop it silently — carry it forward to Step 4/5 and flag the uncertainty there rather than deciding unilaterally.
 
### Step 4 — Surface contradictions first
 
Before drafting any summaries, check the surviving candidates against the existing docs they'd map to. If something learned in this session conflicts with what's currently written (e.g. docs say a service is stateless, but the conversation established it now holds session state), do not fold this quietly into Step 5.
 
Instead, raise each contradiction explicitly and resolve it as one of three outcomes before moving on:
 
1. **The conversation was correct, the docs are outdated** → update the docs directly to match the conversation. Since this is an explicit, confirmed correction, write it straight into the target doc — it does not need to go through the Step 6 yes/no batch again.
2. **The docs are correct, the conversation was mistaken** → drop the candidate. Don't document it, and don't carry it into Step 5/6.
3. **Neither is wrong — it's a misunderstanding or scope difference** (both are true, just describing different things, timeframes, or configurations) → ask the user whether this distinction is worth documenting at all (e.g. as a clarifying note in the docs) or whether it's not worth the ink. Treat their answer as final for this item — don't re-ask it in Step 6.
Ask about each contradiction directly, e.g.:
> "The docs currently say X, but this conversation suggests Y. Which is correct — should I update the docs, or did I misunderstand?"
 
Resolve all contradictions (into one of the three outcomes above) before moving on to Step 5, which only concerns the non-contradictory surviving candidates.
 
### Step 5 — Map each remaining item to the best-fitting existing doc
 
Using the documentation map from Step 1, assign each surviving candidate to the specific existing file/section it best fits. The goal is to **fill gaps in existing documentation**, not create a new parallel log — prefer editing/extending an existing section over adding a new top-level file.
 
This mapping step is inherently a judgment call and the hardest part to get consistently right — when a candidate could plausibly fit two sections, or fits nothing well, say so in the summary you produce in Step 6 rather than silently picking one.
 
### Step 6 — Summarize and confirm (max 5 items)
 
Condense the surviving candidates into at most 5 short, meaningful summaries (merge related items if there are more than 5 — don't just drop the excess). For each one, ask a simple yes/no question using the available ask-tool, one at a time or batched if the tool supports multiple questions:
 
> "Should I document this: **[one-sentence summary]** → into `[target file/section]`? Yes / No"
 
If a candidate didn't cleanly map to one section in Step 5, say so in the question itself (e.g. "...into `docs/architecture.md` or `docs/api.md` — not sure which fits better, let me know").
 
Because most of these projects are git-versioned, the user has full ability to review the diff and roll back afterward — so lean toward asking rather than silently skipping, but don't over-ask on things that are clearly generic or clearly temporary (those were already filtered in Step 3).
 
### Step 7 — Write the approved changes
 
For each "Yes", edit the target file directly:
- Extend or fill in the existing section rather than appending a disconnected note, matching the surrounding doc's tone and structure.
- Keep edits scoped to what was approved — don't use this as an opportunity to rewrite unrelated parts of the doc.
- After writing, briefly list what was changed and where (file + section), so the user has a clear trail to review in their git diff.
For each "No", skip it — don't write it anywhere, and don't ask again later in the same session.
 
## Guardrails
 
- Never write to documentation without the user's confirmation from Step 6 (except items resolved in Step 4, and the AGENTS.md documentation-map entry in Step 1, both of which are already explicitly confirmed by the user before being written).
- Never fabricate facts to fill a documentation gap — if the conversation didn't establish it, don't write it.
- Keep summaries factual and concise; this isn't a chat transcript dump.
- If the repo has no docs at all beyond AGENTS.md, it's fine for the "existing doc" to be a new section within a doc file the user just confirmed in Step 1 — the point is deliberate placement, not necessarily a pre-existing file.
- **Confidentiality**: never write client names, pricing, contract terms, credentials, tokens, or personal data into documentation just because they came up in the conversation — even if the surrounding knowledge is otherwise worth keeping. Summarize around the sensitive detail (e.g. "the client's legacy auth provider" rather than naming it) unless the target doc is clearly scoped to hold that kind of client-specific detail (e.g. a client-specific internal runbook) and the user confirms it belongs there.
- If a no-op run happens (candidates were found but all filtered out in Step 3, or none were found at all), say so briefly rather than going silent — e.g. "Reviewed this session — nothing met the bar for documentation."