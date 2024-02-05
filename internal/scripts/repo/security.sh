#!/usr/bin/env bash
#
# Set GitHub Code security and analysis for repository.
#
# This script set following:
#
# - Code security and analysis
#     - Secret scanning
#     - Push protection
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
printf "Code security and analysis: \033[32m%s\033[0m\n" "${repository}"

set -x

# Update a repository
#
# - security_and_analysis: Specify which security and analysis features to enable or disable for the repository.
#     - secret_scanning: Use the status property to enable or disable secret scanning for this repository.
#     - secret_scanning_push_protection: Use the status property to enable or disable secret scanning push protection for this repository.
#
# API Document:
# https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#update-a-repository
echo '{"security_and_analysis":{"secret_scanning":{"status":"enabled"}}}' \
  | gh api \
    --method PATCH \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/${repository}" \
    --input - >/dev/null

echo '{"security_and_analysis":{"secret_scanning_push_protection":{"status":"enabled"}}}' \
  | gh api \
    --method PATCH \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/${repository}" \
    --input - >/dev/null

gh api \
  --method GET \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/${repository}"
