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
readonly CP_DATA_SET="${ROOT_DIR}/test_data/cp_data_set.sh"
# - - - - - - - - - - - - - - - - -
# create temporary git repos from test-data
readonly CUSTOM=${1}
readonly EXERCISES=${2}
readonly LANGUAGES=${3}

"${CP_DATA_SET}" "${C_TMP_DIR}" "${CUSTOM}"
"${CP_DATA_SET}" "${E_TMP_DIR}" "${EXERCISES}"
"${CP_DATA_SET}" "${L_TMP_DIR}" "${LANGUAGES}"

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
