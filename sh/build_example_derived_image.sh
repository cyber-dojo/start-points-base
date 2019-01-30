#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

readonly CUSTOM=${1}
readonly EXERCISES=${2}
readonly LANGUAGES=${3}

# - - - - - - - - - - - - - - - - -
# create tmp dirs
# Put this off root-dir so it works for DockerToolbox.
readonly TMP_DIR=$(mktemp -d "${ROOT_DIR}/tmp/cyber-dojo-start-points-base.XXX")
rm_tmp_dir() { rm -rf "${TMP_DIR}" > /dev/null; }
trap rm_tmp_dir EXIT

# - - - - - - - - - - - - - - - - -
# create git repos in tmp dirs from named test-data-sets
readonly CP_DATA_SET="${ROOT_DIR}/test_data/cp_data_set.sh"

#"${CP_DATA_SET}" "${TMP_DIR}/custom"    "${CUSTOM}"
"${CP_DATA_SET}" "${TMP_DIR}/exercises" "${EXERCISES}"
"${CP_DATA_SET}" "${TMP_DIR}/languages" "${LANGUAGES}"

# problem here is docker-machine means TMP_DIR will
# not be visible outside the default VM...
# I think I need to specify a more local dir
docker run \
  --user root \
  --rm \
  --tmpfs /tmp \
  --volume "${TMP_DIR}/custom:/app/tmp/custom:rw" \
  cyberdojo/create-start-points-test-data \
    "/app/tmp/custom" \
    "${CUSTOM}"

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
