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
  local dir_name="${1}"
  local data_set_name="${2}"
  docker run \
    --user root \
    --rm \
    --tmpfs /tmp \
    --volume "${TMP_DIR}/${dir_name}:/app/tmp/${dir_name}:rw" \
    cyberdojo/create-start-points-test-data \
      "/app/tmp/${dir_name}" \
      "${data_set_name}"
}

create_git_repo_from_named_data_set cust "${1}"
create_git_repo_from_named_data_set ex   "${2}"
create_git_repo_from_named_data_set ltf  "${3}"

# - - - - - - - - - - - - - - - - -
# build the named image from the git repos in the tmp dirs
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly IMAGE_NAME=cyberdojo/start-points-test

"${ROOT_DIR}/${SCRIPT}"     \
  "${IMAGE_NAME}"           \
    --custom                \
      "file://${TMP_DIR}/cust" \
    --exercises             \
      "file://${TMP_DIR}/ex" \
    --languages             \
      "file://${TMP_DIR}/ltf" \
