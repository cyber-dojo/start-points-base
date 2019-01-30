#!/bin/bash
set -e

readonly C_TMP_DIR=$(mktemp -d)
readonly E_TMP_DIR=$(mktemp -d)
readonly L_TMP_DIR=$(mktemp -d)

cleanup()
{
  rm -rf "${C_TMP_DIR}" > /dev/null
  rm -rf "${E_TMP_DIR}" > /dev/null
  rm -rf "${L_TMP_DIR}" > /dev/null
}
trap cleanup EXIT

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

# - - - - - - - - - - - - - - - - -
# create temporary git repos from test-data
"${ROOT_DIR}/test_data/setup_data_set.sh" "${C_TMP_DIR}" custom
"${ROOT_DIR}/test_data/setup_data_set.sh" "${E_TMP_DIR}" exercises
"${ROOT_DIR}/test_data/setup_data_set.sh" "${L_TMP_DIR}" languages

# - - - - - - - - - - - - - - - - -
# build the named image from the temporary git repos
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly IMAGE_NAME=cyberdojo/start-points-test

"${ROOT_DIR}/${SCRIPT}"   \
  ${IMAGE_NAME}           \
    --custom              \
      file://${C_TMP_DIR} \
    --exercises           \
      file://${E_TMP_DIR} \
    --languages           \
      file://${L_TMP_DIR} \
