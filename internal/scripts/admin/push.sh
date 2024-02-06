#!/usr/bin/env bash
#
# Push and merge
set -euo pipefail

USAGE="Usage: $0 <BRANCH> <BASE_DIR>"
usage() {
  echo "${USAGE}"
}

# Target branch
branch="${1:-}"
if [[ "${branch}" == "" ]]; then
  usage
  exit 2
fi

# Describe base directory
base_dir="${2:-${BASE_DIR:-}}"
if [[ "${base_dir}" == "" ]]; then
  usage
  exit 2
fi
printf "Based on: \033[35m%s\033[0m\n\n" "${base_dir}"

# Describe target directories
exclude_options=(-e 'makefiles/' -e 'tmp/' -e '\.git/')
dirs+=("$(find "${base_dir}" -type d -maxdepth 2 -name '*-action' | grep -v "${exclude_options[@]}" | sort -u)")
dirs+=("$(find "${base_dir}" -type d -maxdepth 2 -name '*-workflows' | grep -v "${exclude_options[@]}" | sort -u)")
dirs+=("$(find "${base_dir}" -type d -maxdepth 2 -name 'template*' | grep -v "${exclude_options[@]}" | sort -u)")
dirs+=("$(find "${base_dir}" -type d -maxdepth 2 -name 'makefiles' -or -name 'configurations' | grep -v -e '/tmp' -e '/.git' | sort -u)")

# Ignore shellcheck: Double quote array expansions to avoid re-splitting elements
# shellcheck disable=SC2068
for dir in ${dirs[@]}; do
  pushd "${dir}" >/dev/null
  if ! git branch --list | grep -q "${branch}"; then
    continue
  fi
  printf "Push: \033[32m%s\033[0m\n" "${dir}"
  git switch main
  git switch "${branch}"
  git push origin "${branch}"
  gh pr create --fill-first
  sleep 1
  gh pr merge --merge --auto
  git switch main
  git pull --rebase origin main
  popd >/dev/null
done
