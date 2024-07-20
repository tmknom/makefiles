#!/usr/bin/env bash
#
# Commit
set -euo pipefail

USAGE="Usage: $0 <BRANCH> <MESSAGE> <BASE_DIR>"
usage() {
  echo "${USAGE}"
}

# Target branch
branch="${1:-}"
if [[ "${branch}" == "" ]]; then
  usage
  exit 2
fi

message="${2:-}"
if [[ "${message}" == "" ]]; then
  usage
  exit 2
fi

# Describe base directory
base_dir="${3:-${BASE_DIR:-}}"
if [[ "${base_dir}" == "" ]]; then
  usage
  exit 2
fi
printf "Based on: \033[35m%s\033[0m\n\n" "${base_dir}"

# Describe target directories
source "$(realpath "$(dirname "$0")")/functions/dirs.sh"
dirs="$(describe_dirs "${base_dir}")"
printf "Run dirs:\n\033[35m%s\033[0m\n\n" "${dirs}"

# Ignore shellcheck: Double quote array expansions to avoid re-splitting elements
# shellcheck disable=SC2068
for dir in ${dirs[@]}; do
  pushd "${dir}" >/dev/null
  printf "Pull: \033[32m%s\033[0m\n" "${dir}"
  git stash
  git switch main
  git switch -c "${branch}"
  git add .
  git commit -m "${message}"
  git switch main
  git stash pop || true
  popd >/dev/null
done
