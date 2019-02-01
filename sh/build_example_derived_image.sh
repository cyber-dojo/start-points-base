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
  #TODO
  #if using_DockerToolbox; then
  #  TODO: Check ROOT_DIR is under /Users
  #fi
  [ -d "${ROOT_DIR}/tmp" ] || mkdir "${ROOT_DIR}/tmp"
  TMP_DIR=$(mktemp -d "${ROOT_DIR}/tmp/cyber-dojo-start-points-base.XXX")
  chmod 777 "${TMP_DIR}"
}

remove_TMP_DIR()
{
  rm -rf "${TMP_DIR}" > /dev/null;
}

# - - - - - - - - - - - - - - - - -

create_git_repo_in_TMP_DIR_from()
{
  local data_set_name="${1}"
  local data_dir="${TMP_DIR}/${data_set_name}"
  local user_id=$(id -u $(whoami))
  
  docker run                                \
    --rm                                    \
    --volume "${data_dir}:/app/tmp/:rw"     \
    cyberdojo/create-start-points-test-data \
      "${data_set_name}"                    \
      "/app/tmp"                            \
      "${user_id}"

  echo "${data_dir}"
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

make_TMP_DIR
trap remove_TMP_DIR EXIT

readonly C_TMP_DIR=$(create_git_repo_in_TMP_DIR_from good_custom)
readonly E_TMP_DIR=$(create_git_repo_in_TMP_DIR_from good_exercises)
readonly L_TMP_DIR=$(create_git_repo_in_TMP_DIR_from good_languages)

"${ROOT_DIR}/$(build_image_script_name)" \
  "$(image_name)"                        \
    --custom                             \
      "file://${C_TMP_DIR}"              \
    --exercises                          \
      "file://${E_TMP_DIR}"              \
    --languages                          \
      "file://${L_TMP_DIR}"
