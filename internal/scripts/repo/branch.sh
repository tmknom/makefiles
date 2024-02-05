#!/usr/bin/env bash
#
# Set GitHub Protected branches for repository.
#
# This script set following:
#
# - Require a pull request before merging
#     - Require approvals: 0
# - Require status checks to pass before merging
set -euo pipefail

USAGE="Usage: $0 <OWNER/REPO>"
usage() {
  echo "${USAGE}"
}

if [[ "$(\command -v gh 2>/dev/null)" == "" ]]; then
  echo "$0: error: not found gh (GitHub CLI)"
  exit 2
fi

# Set repository: OWNER/REPO
repository="${1:-}"
if [[ "${repository}" == "" ]]; then
  usage
  exit 2
fi
printf "Protected branches: \033[32m%s\033[0m\n" "${repository}"

set -x

# Describe default branch
default_branch="$(gh repo view "${repository}" --json=defaultBranchRef --jq=.defaultBranchRef.name)"

# Update branch protection
#
# - required_pull_request_reviews: Require at least one approving review on a pull request, before merging. Set to null to disable.
#     - required_approving_review_count: Specify the number of reviewers required to approve pull requests.
# - required_status_checks: Require status checks to pass before merging.
#     - strict: Require branches to be up to date before merging.
#
# API Document:
# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#update-branch-protection
echo '{"required_pull_request_reviews":{"required_approving_review_count":0},"required_status_checks":{"strict":false,"contexts":[]},"enforce_admins":null,"restrictions":null}' \
  | gh api \
    --method PUT \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/${repository}/branches/${default_branch}/protection" \
    --input - >/dev/null

gh api \
  --method GET \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/${repository}/branches/${default_branch}/protection"
