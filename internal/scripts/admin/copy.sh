#!/usr/bin/env bash
#
# Copy file
set -euo pipefail

USAGE="Usage: $0 <SRC> <DEST> <BASE_DIR>"
usage() {
  echo "${USAGE}"
}

# Source file
src="${1:-}"
if [[ "${src}" == "" ]]; then
  usage
  exit 2
fi

# Destination file
dest="${2:-}"
if [[ "${dest}" == "" ]]; then
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
  printf "Copy: \033[32m%s\033[0m\n" "${dir}"
  cp -R "${src}" "${dest}"
  popd >/dev/null
done
