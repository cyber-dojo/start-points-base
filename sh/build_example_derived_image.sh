#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

# - - - - - - - - - - - - - - - - -
# create tmp dirs
# This off root-dir (and not /tmp say) so it works in Docker-Toolbox.
if [ ! -d "${ROOT_DIR}/tmp" ]; then
  mkdir "${ROOT_DIR}/tmp"
fi
readonly TMP_DIR=$(mktemp -d "${ROOT_DIR}/tmp/cyber-dojo-start-points-base.XXX")
rm_tmp_dir() { rm -rf "${TMP_DIR}" > /dev/null; }
trap rm_tmp_dir EXIT

# - - - - - - - - - - - - - - - - -

create_git_repo_from_named_data_set()
{
  local data_set_name="${1}"
  docker run \
    --user root \
    --rm \
    --volume "${TMP_DIR}/${data_set_name}:/app/tmp/${data_set_name}:rw" \
    cyberdojo/create-start-points-test-data \
      "${data_set_name}" \
      "/app/tmp/${data_set_name}"
}

create_git_repo_from_named_data_set good_custom
create_git_repo_from_named_data_set good_exercises
create_git_repo_from_named_data_set good_languages

# - - - - - - - - - - - - - - - - -
# build the named image from the git repos in the tmp dirs
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly IMAGE_NAME=cyberdojo/start-points-test

"${ROOT_DIR}/${SCRIPT}"     \
  "${IMAGE_NAME}"           \
    --custom                \
      "file://${TMP_DIR}/good_custom" \
    --exercises             \
      "file://${TMP_DIR}/good_exercises" \
    --languages             \
      "file://${TMP_DIR}/good_languages" \
