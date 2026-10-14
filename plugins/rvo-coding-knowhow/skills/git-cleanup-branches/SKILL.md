---
name: git-cleanup-branches
description: Find merged local Git branches using Git ancestry, then gh for remaining branches on GitHub, and delete them after confirmation. Use when asked to clean up local branches, including squash-merged branches.
---

# Clean up branches

1. Confirm the repository and remote from the request or repository configuration;
   ask when ambiguous. In that repository, run the bundled
   [discovery script](./scripts/find-candidates.sh) using its absolute path:

   ```bash
   bash "<skill-directory>/scripts/find-candidates.sh" "<remote>"
   ```

   Optionally supply a target branch as the second argument; the default is the
   remote's default branch. Requires Bash and Git, plus authenticated `gh` for
   GitHub lookup. The script fetches/prunes, lists normal merges against the
   fetched target, and prints merged PR metadata for remaining branches on
   `github.com`, `ghe.com`, or their subdomains. It never deletes branches.
   Report stderr and failures explicitly; failed runs may have partial output.
2. Review the output before proposing deletion:
   - Keep default/target branches, known protected branches, and branches checked
     out in any worktree.
   - Git ancestry candidates already have their tips merged into the target.
   - PR output is evidence to review, not an automatic deletion list. Require
     the local tip to equal `headRefOid` and the head branch and repository to
     match the upstream source. Inspect its remote URL; ask if identity is
     unclear. Keep mismatches and branches with unverified metadata.
   - Verify each PR's `mergeCommit.oid` is reachable from the printed target
     with `git merge-base --is-ancestor "<merge-sha>" "<target-ref>"`.
     Exit 0 confirms ancestry, 1 means unmerged, and other exits are errors.
   - PR queries are limited to 100 results per branch. If a query returns 100,
     increase the limit before concluding that no matching PR exists.
3. Show eligible branches with tip SHAs, targets, and evidence (Git ancestry or
   PR link). Explain retained branches and incomplete/skipped PR lookup.
   If no candidates qualify, report that explicitly.
4. Ask which listed branches the user approves for local deletion. Explain that
   `-D` bypasses Git's upstream/HEAD merge check; the reviewed target or PR
   supplies the merge evidence. Model invocation is not deletion approval.
5. Before deleting, recheck each approved tip, merge evidence, and worktree
   status. Retain changed or newly checked-out branches. Delete only approved,
   unchanged names, individually:

   ```bash
   git branch -D -- "<approved-local-branch>"
   ```

   Leave remote branches, worktrees, and working files intact. Report every
   deletion error.
6. Re-list local branches. Finish when every approved branch is verified absent
   or reported as retained with a reason or deletion error.
