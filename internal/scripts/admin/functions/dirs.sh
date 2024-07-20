#!/usr/bin/env bash
#
# Describe directories

function describe_dirs(){
  local base_dir="$1"
  local excludes=(-e 'makefiles/' -e '\.local/' -e '\.git/' -e 'tmp/')
  grep -v "${excludes[@]}" <<<"$(find_dirs "${base_dir}")" | sort -u
}

function find_dirs(){
  local base_dir="$1"
  find "${base_dir}" -type d -maxdepth 2 -name '*-action' || echo ''
  find "${base_dir}" -type d -maxdepth 2 -name '*-workflows' || echo ''
  find "${base_dir}" -type d -maxdepth 2 -name 'template*' || echo ''
  find "${base_dir}" -type d -maxdepth 2 -name 'configurations' || echo ''
}
