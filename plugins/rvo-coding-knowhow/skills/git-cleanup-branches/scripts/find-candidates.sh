#!/usr/bin/env bash
set -euo pipefail
trap 'printf "Discovery failed at line %s; do not treat partial output as complete.\n" "$LINENO" >&2' ERR

remote=${1:?Usage: bash find-candidates.sh REMOTE [TARGET-BRANCH]}
git fetch --prune "$remote"
default=$(git ls-remote --symref "$remote" HEAD | awk '$1 == "ref:" { sub("^refs/heads/", "", $2); print $2 }')
[[ -n "$default" ]] || { echo "Cannot resolve remote default branch." >&2; exit 1; }
target=${2:-$default}
target_ref="refs/remotes/$remote/$target"
git rev-parse --verify "$target_ref^{commit}"
printf '\nDefault: %s\nTarget: %s\n\nWorktrees:\n' "$default" "$target_ref"
git worktree list --porcelain
printf '\nGit ancestry candidates (review protected and checked-out branches):\n'
git branch --merged "$target_ref" --format='%(refname:lstrip=2) %(objectname)'
remaining=$(git branch --no-merged "$target_ref" --format='%(refname:lstrip=2)')
[[ -n "$remaining" ]] || exit 0

url=$(git remote get-url "$remote")
if [[ "$url" =~ ^(https?://|ssh://)([^/@]+@)?([^/:]+)(:[0-9]+)?/(.+)$ ]]; then
  host=${BASH_REMATCH[3]}; repo=${BASH_REMATCH[5]}
elif [[ "$url" =~ ^([^/@:]+@)?([^/:]+):(.+)$ ]]; then
  host=${BASH_REMATCH[2]}; repo=${BASH_REMATCH[3]}
else
  echo "PR lookup skipped: unsupported remote URL." >&2; exit 0
fi
case "$host" in
  github.com|*.github.com|ghe.com|*.ghe.com) ;;
  *) echo "PR lookup skipped: not a GitHub host ($host)." >&2; exit 0 ;;
esac
repo=${repo%/}; repo=${repo%.git}
gh auth status --hostname "$host"
while IFS= read -r branch; do
  printf '\nPR review for local branch: %s\n' "$branch"
  git for-each-ref --format='%(objectname) %(upstream:remotename) %(upstream:remoteref)' "refs/heads/$branch"
  head=$(git for-each-ref --format='%(upstream:remoteref)' "refs/heads/$branch")
  head=${head#refs/heads/}
  gh pr list --repo "$host/$repo" --state merged --base "$target" \
    --head "${head:-$branch}" --limit 100 \
    --json number,url,headRefName,headRefOid,headRepository,headRepositoryOwner,baseRefName,mergeCommit,mergedAt
done <<< "$remaining"
