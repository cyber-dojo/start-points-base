#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

create_git_repo_from_named_data_set()
{
  local tmp_dir="${1}"
  local data_set_name="${2}"
  docker run \
    --user root \
    --rm \
    --volume "${tmp_dir}/${data_set_name}:/app/tmp/${data_set_name}:rw" \
    cyberdojo/create-start-points-test-data \
      "${data_set_name}" \
      "/app/tmp/${data_set_name}"
}

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

declare TMP_DIR=''

make_TMP_DIR()
{
  if using_DockerToolbox; then
    [ -d "${ROOT_DIR}/tmp" ] || mkdir "${ROOT_DIR}/tmp"
    TMP_DIR=$(mktemp -d "${ROOT_DIR}/tmp/cyber-dojo-start-points-base.XXX")
  else
    TMP_DIR=$(mktemp -d)
  fi
}

remove_TMP_DIR()
{
  rm -rf "${TMP_DIR}" > /dev/null;
}
trap remove_TMP_DIR EXIT

# - - - - - - - - - - - - - - - - -

make_TMP_DIR
create_git_repo_from_named_data_set "${TMP_DIR}" good_custom
create_git_repo_from_named_data_set "${TMP_DIR}" good_exercises
create_git_repo_from_named_data_set "${TMP_DIR}" good_languages

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

"${ROOT_DIR}/$(build_image_script_name)"     \
  "$(image_name)"           \
    --custom                \
      "file://${TMP_DIR}/good_custom" \
    --exercises             \
      "file://${TMP_DIR}/good_exercises" \
    --languages             \
      "file://${TMP_DIR}/good_languages" \
