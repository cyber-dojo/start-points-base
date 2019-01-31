#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly DATA_SET_NAME="${1}"
readonly TARGET_DIR="${2}"

make_target_dir()
{
  mkdir -p "${TARGET_DIR}"
}

create_data_set_in_target_dir()
{
  case "${DATA_SET_NAME}" in
     good_custom) cp -R "${MY_DIR}/${DATA_SET_NAME}" "${TARGET_DIR}";;
  good_exercises) cp -R "${MY_DIR}/${DATA_SET_NAME}" "${TARGET_DIR}";;
  good_languages) cp -R "${MY_DIR}/${DATA_SET_NAME}" "${TARGET_DIR}";;
               *) "${MY_DIR}/make_data_set.rb" "${DATA_SET_NAME}" "${TARGET_DIR}";;
  esac
}

create_git_repo_in_target_dir()
{
  cd "${TARGET_DIR}"
  git init > /dev/null
  git config --global user.email "jon@jaggersoft.com"
  git config --global user.name "Jon Jagger"
  git add .
  git commit --message="initial commit" > /dev/null
}

make_target_dir
create_data_set_in_target_dir
create_git_repo_in_target_dir
