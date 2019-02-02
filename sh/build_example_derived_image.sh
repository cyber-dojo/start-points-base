#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

exit_if_bad_ROOT_DIR()
{
  if using_DockerToolbox && on_Mac; then
    if [ "${ROOT_DIR:0:6}" != "/Users" ]; then
      echo 'ERROR'
      echo 'You are using Docker-Toolbox for Mac'
      echo "This script lives off ${ROOT_DIR}"
      echo 'It must live off /Users so the docker-context'
      echo "is automatically mounted into the default VM"
      exit 1
    fi
  fi
}

using_DockerToolbox()
{
  [ -n "${DOCKER_MACHINE_NAME}" ]
}

on_Mac()
{
  # https://stackoverflow.com/questions/394230
  [[ "$OSTYPE" == "darwin"* ]]
}

# - - - - - - - - - - - - - - - - -

declare TMP_DIR=''

make_TMP_DIR()
{
  [ -d "${ROOT_DIR}/tmp" ] || mkdir "${ROOT_DIR}/tmp"
  TMP_DIR=$(mktemp -d "${ROOT_DIR}/tmp/cyber-dojo-start-points-base.XXX")
  trap remove_TMP_DIR EXIT
  chmod 777 "${TMP_DIR}"
}

remove_TMP_DIR()
{
  rm -rf "${TMP_DIR}" > /dev/null
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

exit_if_bad_ROOT_DIR
make_TMP_DIR

#readonly C1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from custom-Tennis)
readonly C2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from custom-Yahtzee)
readonly E1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-bowling-game)
readonly E2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-fizz-buzz)
readonly E3_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-leap-years)
readonly E4_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-tiny-maze)
readonly L1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from ltf-csharp-nunit)
readonly L2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from ltf-python-unittest)
readonly L3_TMP_DIR=$(create_git_repo_in_TMP_DIR_from ltf-ruby-minitest)

"${ROOT_DIR}/$(build_image_script_name)" \
  "$(image_name)"                        \
    --custom                             \
      "file://${C2_TMP_DIR}"             \
    --exercises                          \
      "file://${E1_TMP_DIR}"             \
      "file://${E2_TMP_DIR}"             \
      "file://${E3_TMP_DIR}"             \
      "file://${E4_TMP_DIR}"             \
    --languages                          \
      "file://${L1_TMP_DIR}"             \
      "file://${L2_TMP_DIR}"             \
      "file://${L3_TMP_DIR}"
