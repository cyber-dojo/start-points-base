#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly TARGET_DIR="${1}"          # eg /tmp/...
readonly DATA_SET_NAME="${2}"       # eg custom
readonly SRC_DIR="${MY_DIR}/${DATA_SET_NAME}"

create_git_repo()
{
  git init
  git config --global user.email "jon@jaggersoft.com"
  git config --global user.name "Jon Jagger"
  git add .
  git commit -m "initial commit" > /dev/null
}

cp -R "${SRC_DIR}/" "${TARGET_DIR}"
cd "${TARGET_DIR}" && create_git_repo
