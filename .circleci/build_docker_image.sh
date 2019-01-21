#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly IMAGE_NAME=cyberdojo/start-points

# - - - - - - - - - - - - - - - - -
# create git repos from test-data
readonly E_TMP_DIR=$(mktemp -d /tmp/cyber-dojo-start-point-exercises.XXXXXXXXX)

cleanup()
{
  rm -rf "${E_TMP_DIR}" > /dev/null
}
trap cleanup EXIT

readonly TARGET_DIR="${ROOT_DIR}/test/data/exercises"
cp -R "${TARGET_DIR}/" "${E_TMP_DIR}"
cd "${E_TMP_DIR}" \
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
    file://${E_TMP_DIR} \
    https://github.com/cyber-dojo/start-points-languages.git \
    https://github.com/cyber-dojo/start-points-custom.git    \
