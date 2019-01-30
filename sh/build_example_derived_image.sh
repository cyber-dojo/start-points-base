#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

# - - - - - - - - - - - - - - - - -
# create tmp dirs
# This off root-dir (and not /tmp say) so it works for Docker-Toolbox.
readonly TMP_DIR=$(mktemp -d "${ROOT_DIR}/tmp/cyber-dojo-start-points-base.XXX")
rm_tmp_dir() { rm -rf "${TMP_DIR}" > /dev/null; }
trap rm_tmp_dir EXIT

# - - - - - - - - - - - - - - - - -

create_git_repo_from_named_data_set()
{
  local repo_type="${1}"
  local data_set_name="${2}"
  docker run \
    --user root \
    --rm \
    --tmpfs /tmp \
    --volume "${TMP_DIR}/${repo_type}:/app/tmp/${repo_type}:rw" \
    cyberdojo/create-start-points-test-data \
      "/app/tmp/${repo_type}" \
      "${data_set_name}"
}

readonly CUSTOM=${1}
readonly EXERCISES=${2}
readonly LANGUAGES=${3}

create_git_repo_from_named_data_set custom    "${CUSTOM}"
create_git_repo_from_named_data_set exercises "${EXERCISES}"
create_git_repo_from_named_data_set languages "${LANGUAGES}"

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
