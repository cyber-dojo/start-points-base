#!/bin/bash
set -e

readonly CUSTOM=${1}
readonly EXERCISES=${2}
readonly LANGUAGES=${3}

# - - - - - - - - - - - - - - - - -
# create tmp dirs
readonly TMP_DIR=$(mktemp -d)
cleanup() { rm -rf "${TMP_DIR}" > /dev/null; }
trap cleanup EXIT
readonly C_TMP_DIR="${TMP_DIR}/custom"
readonly E_TMP_DIR="${TMP_DIR}/exercises"
readonly L_TMP_DIR="${TMP_DIR}/languages"
mkdir "${C_TMP_DIR}"
mkdir "${E_TMP_DIR}"
mkdir "${L_TMP_DIR}"

# - - - - - - - - - - - - - - - - -
# create git repos in tmp dirs from named test-data-sets
readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly CP_DATA_SET="${ROOT_DIR}/test_data/cp_data_set.sh"

"${CP_DATA_SET}" "${C_TMP_DIR}" "${CUSTOM}"
"${CP_DATA_SET}" "${E_TMP_DIR}" "${EXERCISES}"
"${CP_DATA_SET}" "${L_TMP_DIR}" "${LANGUAGES}"

# - - - - - - - - - - - - - - - - -
# build the named image from the git repos in the tmp dirs
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly IMAGE_NAME=cyberdojo/start-points-test

"${ROOT_DIR}/${SCRIPT}"     \
  "${IMAGE_NAME}"           \
    --custom                \
      "file://${C_TMP_DIR}" \
    --exercises             \
      "file://${E_TMP_DIR}" \
    --languages             \
      "file://${L_TMP_DIR}" \
