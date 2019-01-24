#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly IMAGE_NAME=cyberdojo/start-points

# - - - - - - - - - - - - - - - - -
# create temporary git repos from test-data
readonly C_TMP_DIR=$(mktemp -d /tmp/cyber-dojo-start-point-custom.XXXXXXXXX)
readonly E_TMP_DIR=$(mktemp -d /tmp/cyber-dojo-start-point-exercises.XXXXXXXXX)
readonly L_TMP_DIR=$(mktemp -d /tmp/cyber-dojo-start-point-languages.XXXXXXXXX)

cleanup()
{
  rm -rf "${C_TMP_DIR}" > /dev/null
  rm -rf "${E_TMP_DIR}" > /dev/null
  rm -rf "${L_TMP_DIR}" > /dev/null
}
trap cleanup EXIT

create_git_repo()
{
  git init
  git config --global user.email "jon@jaggersoft.com"
  git config --global user.name "Jon Jagger"
  git add .
  git commit -m "initial commit" > /dev/null
}

readonly C_TARGET_DIR="${ROOT_DIR}/test/data/custom"
cp -R "${C_TARGET_DIR}/" "${C_TMP_DIR}"
cd "${C_TMP_DIR}" && create_git_repo

readonly E_TARGET_DIR="${ROOT_DIR}/test/data/exercises"
cp -R "${E_TARGET_DIR}/" "${E_TMP_DIR}"
cd "${E_TMP_DIR}" && create_git_repo

readonly L_TARGET_DIR="${ROOT_DIR}/test/data/languages"
cp -R "${L_TARGET_DIR}/" "${L_TMP_DIR}"
cd "${L_TMP_DIR}" && create_git_repo

# - - - - - - - - - - - - - - - - -
# build the named image from the named repos
"${ROOT_DIR}/${SCRIPT}" \
  ${IMAGE_NAME} \
    --custom \
      file://${C_TMP_DIR} \
    --exercises \
      file://${E_TMP_DIR} \
    --languages \
      file://${L_TMP_DIR} \
