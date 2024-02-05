#!/usr/bin/env bash
#
# Set GitHub Repository to General
#
# This script set following:
#
# - General
#     - Automatically delete head branches
#     - Allow auto-merge
#     - Always suggest updating pull request branches
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
printf "General: \033[32m%s\033[0m\n" "${repository}"

set -x

# Automatically delete head branches
gh repo edit "${repository}" --delete-branch-on-merge

# Allow auto-merge
gh repo edit "${repository}" --enable-auto-merge

# Always suggest updating pull request branches
gh repo edit "${repository}" --allow-update-branch
