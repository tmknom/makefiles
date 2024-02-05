#!/usr/bin/env bash
#
# Update makefiles
set -euo pipefail

USAGE="Usage: $0 <BASE_DIR>"
usage() {
  echo "${USAGE}"
}

# Describe base directory
base_dir="${1:-${BASE_DIR:-}}"
if [[ "${base_dir}" == "" ]]; then
  usage
  exit 2
fi
printf "Based on: \033[35m%s\033[0m\n\n" "${base_dir}"

# Describe target directories
exclude_options=(-e 'makefiles' -e 'tmp' -e '.git')
dirs+=("$(find "${base_dir}" -type d -maxdepth 2 -name '*-action' | grep -v "${exclude_options[@]}" | sort -u)")
dirs+=("$(find "${base_dir}" -type d -maxdepth 2 -name '*-workflows' | grep -v "${exclude_options[@]}" | sort -u)")
dirs+=("$(find "${base_dir}" -type d -maxdepth 2 -name 'template*' | grep -v "${exclude_options[@]}" | sort -u)")
dirs+=("$(find "${base_dir}" -type d -maxdepth 2 -name 'makefiles' -or -name 'configurations' | grep -v -e '/tmp' -e '/.git' | sort -u)")

# Ignore shellcheck: Double quote array expansions to avoid re-splitting elements
# shellcheck disable=SC2068
for dir in ${dirs[@]}; do
  printf "Update: \033[32m%s\033[0m\n" "${dir}"
  pushd "${dir}" >/dev/null
  make internal/update || true
  popd >/dev/null
done