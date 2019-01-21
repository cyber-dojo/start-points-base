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

readonly C_TARGET_DIR="${ROOT_DIR}/test/data/custom"
cp -R "${C_TARGET_DIR}/" "${C_TMP_DIR}"
cd "${C_TMP_DIR}" \
  && git init \
  && git add . \
  && git commit -m "initial commit" > /dev/null

readonly E_TARGET_DIR="${ROOT_DIR}/test/data/exercises"
cp -R "${E_TARGET_DIR}/" "${E_TMP_DIR}"
cd "${E_TMP_DIR}" \
  && git init \
  && git add . \
  && git commit -m "initial commit" > /dev/null

readonly L_TARGET_DIR="${ROOT_DIR}/test/data/languages"
cp -R "${L_TARGET_DIR}/" "${L_TMP_DIR}"
cd "${L_TMP_DIR}" \
  && git init \
  && git add . \
  && git commit -m "initial commit" > /dev/null

# - - - - - - - - - - - - - - - - -
# build the FROM image so it won't be docker pulled
docker build \
  --tag cyberdojo/start-points-base \
  "${ROOT_DIR}"

  # - - - - - - - - - - - - - - - - -
# smoke test building an image
"${ROOT_DIR}/${SCRIPT}" \
  ${IMAGE_NAME} \
    file://${C_TMP_DIR} \
    file://${E_TMP_DIR} \
    file://${L_TMP_DIR} \
