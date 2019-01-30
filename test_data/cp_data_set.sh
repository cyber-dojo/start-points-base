#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

copy_data_set_to_mounted_volume()
{
  local target_dir="${1}"
  local data_set_name="${2}"
  mkdir -p "${target_dir}"
  cp -R "${MY_DIR}/${data_set_name}" "${target_dir}"
}

create_git_repo()
{
  local target_dir="${1}"
  cd "${target_dir}"
  git init
  git config --global user.email "jon@jaggersoft.com"
  git config --global user.name "Jon Jagger"
  git add .
  git commit -m "initial commit" > /dev/null
}

copy_data_set_to_mounted_volume "${1}" "${2}"
create_git_repo "${1}"
