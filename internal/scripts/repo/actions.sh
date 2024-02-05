#!/usr/bin/env bash
#
# Set GitHub Actions Permissions for repository.
#
# Set permissions for the repository that are allowed to run GitHub Actions,
# and the actions and reusable workflows that are allowed to run.
#
# This script set following:
#
# - Actions permissions
#     - Allow OWNER, and select non-OWNER, actions and reusable workflows
#         - Allow actions created by GitHub
#         - Allow actions by Marketplace verified creators
# - Workflow permissions
#     - Read repository contents and packages permissions
#     - Allow GitHub Actions to create and approve pull requests
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
printf "Actions: \033[32m%s\033[0m\n" "${repository}"

set -x

# Set GitHub Actions permissions for a repository
#
# - enabled: Whether GitHub Actions is enabled on the repository.
# - The permissions policy that controls the actions and reusable workflows that are allowed to run.
#
# API Document:
# https://docs.github.com/en/rest/actions/permissions?apiVersion=2022-11-28#set-github-actions-permissions-for-a-repository
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/${repository}/actions/permissions" \
  -F enabled=true \
  -f allowed_actions="selected"

# Set allowed actions and reusable workflows for a repository
#
# - github_owned_allowed: Whether GitHub-owned actions are allowed. For example, this includes the actions in the actions organization.
# - verified_allowed: Whether actions from GitHub Marketplace verified creators are allowed. Set to true to allow all actions by GitHub Marketplace verified creators.
#
# API Document:
# https://docs.github.com/en/rest/actions/permissions?apiVersion=2022-11-28#set-allowed-actions-and-reusable-workflows-for-a-repository
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/${repository}/actions/permissions/selected-actions" \
  -F github_owned_allowed=true \
  -F verified_allowed=true

# Set default workflow permissions for a repository
#
# - default_workflow_permissions: Read repository contents and packages permissions
# - can_approve_pull_request_reviews: Allow GitHub Actions to create and approve pull requests
#
# API Document:
# https://docs.github.com/en/rest/actions/permissions?apiVersion=2022-11-28#set-default-workflow-permissions-for-a-repository
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/${repository}/actions/permissions/workflow" \
  -f default_workflow_permissions="read" \
  -F can_approve_pull_request_reviews=true
