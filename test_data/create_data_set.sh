#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly DATA_SET_NAME="${1}"
readonly TARGET_DIR="${2}"
readonly USER_ID="${3}"

# - - - - - - - - - - - - - - - - - - - - - - - - -

make_target_dir()
{
  mkdir -p "${TARGET_DIR}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - -

copy_data_set_to_target_dir()
{
  cp -R "${MY_DIR}/${DATA_SET_NAME}/." "${TARGET_DIR}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - -

create_data_set_in_target_dir()
{
  case "${DATA_SET_NAME}" in
  custom-tennis ) copy_data_set_to_target_dir;;
  custom-yahtzee) copy_data_set_to_target_dir;;

  exercises-bowling-game) copy_data_set_to_target_dir;;
  exercises-fizz-buzz   ) copy_data_set_to_target_dir;;
  exercises-leap-years  ) copy_data_set_to_target_dir;;
  exercises-tiny-maze   ) copy_data_set_to_target_dir;;
  exercises-calc-stats  ) copy_data_set_to_target_dir;;
  exercises-gray-code   ) copy_data_set_to_target_dir;;

  languages-csharp-nunit   ) copy_data_set_to_target_dir;;
  languages-python-unittest) copy_data_set_to_target_dir;;
  languages-ruby-minitest  ) copy_data_set_to_target_dir;;
               *) "${MY_DIR}/make_data_set.rb" "${DATA_SET_NAME}" "${TARGET_DIR}";;
  esac
}

# - - - - - - - - - - - - - - - - - - - - - - - - -

create_git_repo_in_target_dir()
{
  cd "${TARGET_DIR}"
  git init > /dev/null
  git config --global user.email "jon@jaggersoft.com"
  git config --global user.name "Jon Jagger"
  git add .
  git commit --message="initial commit" > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - - - - -

set_permissions_on_target_dir()
{
  chmod 777 "${TARGET_DIR}"
  chown -R "${USER_ID}" "${TARGET_DIR}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - -

make_target_dir
create_data_set_in_target_dir
create_git_repo_in_target_dir
set_permissions_on_target_dir
