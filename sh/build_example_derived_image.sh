#!/bin/bash
set -e

readonly CUSTOM=${1}
readonly EXERCISES=${2}
readonly LANGUAGES=${3}

# - - - - - - - - - - - - - - - - -
# create tmp dirs
readonly TMP_DIR=$(mktemp -d)
rm_tmp_dir() { rm -rf "${TMP_DIR}" > /dev/null; }
trap rm_tmp_dir EXIT

# - - - - - - - - - - - - - - - - -
# create git repos in tmp dirs from named test-data-sets
readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly CP_DATA_SETS="${ROOT_DIR}/test_data/cp_data_sets.sh"

"${CP_DATA_SETS}" "${TMP_DIR}" "${CUSTOM}" "${EXERCISES}" "${LANGUAGES}"

# - - - - - - - - - - - - - - - - -
# build the named image from the git repos in the tmp dirs
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly IMAGE_NAME=cyberdojo/start-points-test

"${ROOT_DIR}/${SCRIPT}"     \
  "${IMAGE_NAME}"           \
    --custom                \
      "file://${TMP_DIR}/custom" \
    --exercises             \
      "file://${TMP_DIR}/exercises" \
    --languages             \
      "file://${TMP_DIR}/languages" \
