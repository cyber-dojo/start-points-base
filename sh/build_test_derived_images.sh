#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

exit_if_ROOT_DIR_not_in_context()
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
  # detect OS from bash
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
  chmod 700 "${TMP_DIR}"
}

remove_TMP_DIR()
{
  rm -rf "${TMP_DIR}" > /dev/null
}

# - - - - - - - - - - - - - - - - -

build_image_which_creates_test_data_git_repos()
{
  # This builds cyberdojo/create-start-points-test-data
  "${ROOT_DIR}/test_data/build_docker_image.sh"
}

on_CI()
{
  [[ ! -z "${CIRCLE_SHA1}" ]]
}

build_image_script_name()
{
  if on_CI; then
    # ./circleci/config.yml curls the cyber-dojo script into /tmp
    echo '/tmp/cyber-dojo'
  else
    echo "${ROOT_DIR}/../commander/cyber-dojo"
  fi
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

image_name()
{
  echo 'cyberdojo/test'
}

# - - - - - - - - - - - - - - - - -

build_test_custom_image()
{
  make_TMP_DIR
  readonly C1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from custom-yahtzee)

  "$(build_image_script_name)"    \
    start-point create            \
      "$(image_name)-custom"      \
        --custom                  \
          "file://${C1_TMP_DIR}"
  remove_TMP_DIR
}

# - - - - - - - - - - - - - - - - -

build_test_exercises_image()
{
  make_TMP_DIR
  readonly E1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-bowling-game)
  readonly E2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-fizz-buzz)
  readonly E3_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-leap-years)
  readonly E4_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-tiny-maze)
  readonly E5_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-calc-stats)
  readonly E6_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-gray-code)

  "$(build_image_script_name)"     \
    start-point create             \
      "$(image_name)-exercises"    \
        --exercises                \
          "file://${E1_TMP_DIR}"   \
          "file://${E2_TMP_DIR}"   \
          "file://${E3_TMP_DIR}"   \
          "file://${E4_TMP_DIR}"   \
          "file://${E5_TMP_DIR}"   \
          "file://${E6_TMP_DIR}"
  remove_TMP_DIR
}

# - - - - - - - - - - - - - - - - -

build_test_languages_image()
{
  make_TMP_DIR
  readonly L1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from languages-csharp-nunit)
  readonly L2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from languages-python-unittest)
  readonly L3_TMP_DIR=$(create_git_repo_in_TMP_DIR_from languages-ruby-minitest)

  "$(build_image_script_name)"     \
    start-point create             \
      "$(image_name)-languages"    \
        --languages                \
          "file://${L1_TMP_DIR}"   \
          "file://${L2_TMP_DIR}"   \
          "file://${L3_TMP_DIR}"
  remove_TMP_DIR
}

# - - - - - - - - - - - - - - - - -

build_image_which_creates_test_data_git_repos
exit_if_ROOT_DIR_not_in_context
build_test_custom_image
build_test_exercises_image
build_test_languages_image
