#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
declare TMP_DIR=''

# - - - - - - - - - - - - - - - - -

using_DockerToolbox()
{
  if [ -n "${DOCKER_MACHINE_NAME}" ]; then
    true
  else
    false
  fi
}

# - - - - - - - - - - - - - - - - -

make_TMP_DIR()
{
  if using_DockerToolbox; then
    # TODO: Check ROOT_DIR is under /Users
    [ -d "${ROOT_DIR}/tmp" ] || mkdir "${ROOT_DIR}/tmp"
    TMP_DIR=$(mktemp -d "${ROOT_DIR}/tmp/cyber-dojo-start-points-base.XXX")
  else
    echo "Not using DockerToolbox"
    TMP_DIR=$(mktemp -d)
  fi
}

remove_TMP_DIR()
{
  rm -rf "${TMP_DIR}" > /dev/null;
}

# - - - - - - - - - - - - - - - - -

create_git_repo_in_TMP_DIR_from_data_set()
{
  local data_set_name="${1}"
  docker run \
    --rm \
    --volume "${TMP_DIR}/${data_set_name}:/app/tmp/:rw" \
    cyberdojo/create-start-points-test-data \
      "${data_set_name}" \
      "/app/tmp"
}

# - - - - - - - - - - - - - - - - -

build_image_script_name()
{
  echo 'build_cyber_dojo_start_points_image.sh'
}

image_name()
{
  echo 'cyberdojo/start-points-test'
}

# - - - - - - - - - - - - - - - - -
# build the named image from the git repos in the tmp dirs

make_TMP_DIR
trap remove_TMP_DIR EXIT

create_git_repo_in_TMP_DIR_from_data_set good_custom
create_git_repo_in_TMP_DIR_from_data_set good_exercises
create_git_repo_in_TMP_DIR_from_data_set good_languages

"${ROOT_DIR}/$(build_image_script_name)"     \
  "$(image_name)"           \
    --custom                \
      "file://${TMP_DIR}/good_custom" \
    --exercises             \
      "file://${TMP_DIR}/good_exercises" \
    --languages             \
      "file://${TMP_DIR}/good_languages" \
