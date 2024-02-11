#!/usr/bin/env bash
#
# Execute for all repositories
set -euo pipefail

USAGE="Usage: $0 <COMMAND> <BASE_DIR>"
usage() {
  echo "${USAGE}"
}

# Target branch
commands="${1:-}"
if [[ "${commands}" == "" ]]; then
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
source "$(realpath "$(dirname "$0")")/functions/dirs.sh"
dirs="$(describe_dirs "${base_dir}")"
printf "Run dirs:\n\033[35m%s\033[0m\n\n" "${dirs}"

# Ignore shellcheck: Double quote array expansions to avoid re-splitting elements
# shellcheck disable=SC2068
for dir in ${dirs[@]}; do
  pushd "${dir}" >/dev/null
  printf "Exec: \033[32m%s\033[0m\n" "${dir}"
  /usr/bin/env bash -c "${commands}" || true
  sleep 1
  popd >/dev/null
done
