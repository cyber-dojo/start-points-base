#!/bin/bash -Ee

readonly ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

declare -a TMP_DIRs=()
remove_TMP_DIRS()
{
  for tmp_dir in "${TMP_DIRS[@]}"; do
    if [ -n "${tmp_dir}" ]; then
      rm -rf "${tmp_dir}"
    fi
  done
}
trap remove_TMP_DIRS INT EXIT

make_tmp_dir()
{
  # Must be off ROOT_DIR so docker-context is mounted into default VM
  [ -d "${ROOT_DIR}/tmp" ] || mkdir "${ROOT_DIR}/tmp"
  local -r tmp_dir=$(mktemp -d "${ROOT_DIR}/tmp/XXXXXX")
  TMP_DIRS+=("${tmp_dir}")
  echo "${tmp_dir}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
exit_if_ROOT_DIR_not_in_context()
{
  if using_DockerToolbox && on_Mac; then
    if [ "${ROOT_DIR:0:6}" != "/Users" ]; then
      echo ERROR
      echo You are using Docker-Toolbox for Mac
      echo "This script lives off ${ROOT_DIR}"
      echo It must live off /Users so the docker-context
      echo is automatically mounted into the default VM
      exit 42
    fi
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
using_DockerToolbox()
{
  [ -n "${DOCKER_MACHINE_NAME}" ]
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_Mac()
{
  # detect OS from bash
  # https://stackoverflow.com/questions/394230
  [[ "$OSTYPE" == "darwin"* ]]
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_image_which_creates_test_data_git_repos()
{
  # This builds cyberdojo/create-start-points-test-data
  "${ROOT_DIR}/test_data/build_docker_image.sh"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ -n "${CIRCLE_SHA1}" ]
}

# - - - - - - - - - - - - - - - - - - - - - - - -
cyber_dojo()
{
  local -r name=cyber-dojo
  if [ -x "$(command -v ${name})" ]; then
    echo "${name}"
  else
    local -r tmp_dir=$(make_tmp_dir)
    local -r url="https://raw.githubusercontent.com/cyber-dojo/commander/master/${name}"
    curl --fail --output "${tmp_dir}/${name}" --silent "${url}"
    chmod 700 "${tmp_dir}/${name}"
    echo "${tmp_dir}/${name}"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
create_git_repo_in_TMP_DIR_from()
{
  local data_set_name="${1}"
  local tmp_dir="$(make_tmp_dir)"
  local data_dir="${tmp_dir}/${data_set_name}"
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

# - - - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo cyberdojo/test
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_test_custom_image()
{
  readonly C1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from custom-yahtzee)
  echo
  echo "Building $(image_name)-custom"
  "$(cyber_dojo)"    \
    start-point create            \
      "$(image_name)-custom"      \
        --custom                  \
          "file://${C1_TMP_DIR}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_test_exercises_image()
{
  readonly E1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-bowling-game)
  readonly E2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-fizz-buzz)
  readonly E3_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-leap-years)
  readonly E4_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-tiny-maze)
  readonly E5_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-calc-stats)
  readonly E6_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-gray-code)
  echo
  echo "Building $(image_name)-exercises"
  "$(cyber_dojo)"     \
    start-point create             \
      "$(image_name)-exercises"    \
        --exercises                \
          "file://${E1_TMP_DIR}"   \
          "file://${E2_TMP_DIR}"   \
          "file://${E3_TMP_DIR}"   \
          "file://${E4_TMP_DIR}"   \
          "file://${E5_TMP_DIR}"   \
          "file://${E6_TMP_DIR}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_test_languages_image()
{
  readonly L1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from languages-csharp-nunit)
  readonly L2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from languages-python-unittest)
  readonly L3_TMP_DIR=$(create_git_repo_in_TMP_DIR_from languages-ruby-minitest)
  echo
  echo "Building $(image_name)-languages"
  "$(cyber_dojo)"     \
    start-point create             \
      "$(image_name)-languages"    \
        --languages                \
          "file://${L1_TMP_DIR}"   \
          "file://${L2_TMP_DIR}"   \
          "file://${L3_TMP_DIR}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
assert_base_sha_equal()
{
  local -r IMAGE_BASE_SHA=$(docker run --rm $(image_name)-$2 sh -c 'echo -n ${BASE_SHA}')
  if [ "${1}" != "${IMAGE_BASE_SHA}" ]; then
    echo ERROR
    echo "BASE_SHA=${1} cyberdojo/start-points-base:latest"
    echo "BASE_SHA=${IMAGE_BASE_SHA} $(image_name)-$2"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_image_which_creates_test_data_git_repos
exit_if_ROOT_DIR_not_in_context

build_test_custom_image
build_test_exercises_image
build_test_languages_image

readonly BASE_SHA=$(cd "${ROOT_DIR}" && git rev-parse HEAD)
assert_base_sha_equal "${BASE_SHA}" custom
assert_base_sha_equal "${BASE_SHA}" exercises
assert_base_sha_equal "${BASE_SHA}" languages
