#!/usr/bin/env bash
#
# Configure GitHub for repository.
#
# This script set following:
#
# - General
# - Actions Permissions
# - Code security and analysis
# - Protected branches
set -euo pipefail

USAGE="Usage: $0 <OWNER/REPO>"
usage() {
  echo "${USAGE}"
}

# Set repository: OWNER/REPO
repository="${1:-}"
if [[ "${repository}" == "" ]]; then
  usage
  exit 2
fi

root_dir="$(git rev-parse --show-toplevel)"
self_dir="${root_dir}/internal/scripts/repo"

"${self_dir}/general.sh" "${repository}"
"${self_dir}/actions.sh" "${repository}"
"${self_dir}/security.sh" "${repository}"
"${self_dir}/branch.sh" "${repository}"
