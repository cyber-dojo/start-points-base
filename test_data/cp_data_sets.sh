#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

create_git_repo()
{
  local target_dir="${1}"
  local data_set_name="${2}"
  mkdir "${target_dir}"
  cp -R "${MY_DIR}/${data_set_name}" "${target_dir}"
  cd "${target_dir}"
  git init
  git config --global user.email "jon@jaggersoft.com"
  git config --global user.name "Jon Jagger"
  git add .
  git commit -m "initial commit" > /dev/null
}

create_git_repo "${1}/custom"    "${2}"
create_git_repo "${1}/exercises" "${3}"
create_git_repo "${1}/languages" "${4}"
