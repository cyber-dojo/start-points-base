#!/usr/bin/env bash
set -Eeu

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
  # Must be off root_dir so docker-context is mounted into default VM
  [ -d "$(root_dir)/tmp" ] || mkdir "$(root_dir)/tmp"
  local -r tmp_dir=$(mktemp -d "$(root_dir)/tmp/XXXXXX")
  TMP_DIRS+=("${tmp_dir}")
  echo "${tmp_dir}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
exit_non_zero_unless_root_dir_in_context()
{
  if on_Mac; then
    local -r repo_root=$(root_dir)
    if [ "${repo_root:0:6}" != '/Users' ]; then
      echo_stderr 'ERROR'
      echo_stderr "This script lives off $(root_dir)"
      echo_stderr 'It must live off /Users so the docker-context'
      echo_stderr "is automatically volume-mounted"
      exit 1
    fi
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_image_which_creates_test_data_git_repos()
{
  # This builds cyberdojo/create-start-points-test-data
  "$(root_dir)/test_data/build_docker_image.sh"
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
  local -r data_set_name="${1}"
  local -r tmp_dir="$(make_tmp_dir)"
  local -r data_dir="${tmp_dir}/${data_set_name}"
  local -r user_id=$(id -u $(whoami))

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
test_image_name()
{
  echo cyberdojo/test
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_test_custom_image()
{
  local -r C1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from custom-yahtzee)
  echo
  echo "Building $(test_image_name)-custom"

  "$(cyber_dojo)" start-point create "$(test_image_name)-custom" \
    --custom \
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
  echo "Building $(test_image_name)-exercises"

  "$(cyber_dojo)" start-point create "$(test_image_name)-exercises" \
    --exercises \
      "file://${E1_TMP_DIR}" \
      "file://${E2_TMP_DIR}" \
      "file://${E3_TMP_DIR}" \
      "file://${E4_TMP_DIR}" \
      "file://${E5_TMP_DIR}" \
      "file://${E6_TMP_DIR}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_test_languages_image()
{
  readonly L1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from languages-csharp-nunit)
  readonly L2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from languages-python-unittest)
  readonly L3_TMP_DIR=$(create_git_repo_in_TMP_DIR_from languages-ruby-minitest)
  echo
  echo "Building $(test_image_name)-languages"

  "$(cyber_dojo)" start-point create "$(test_image_name)-languages" \
    --languages \
      "file://${L1_TMP_DIR}" \
      "file://${L2_TMP_DIR}" \
      "file://${L3_TMP_DIR}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
assert_base_sha_equal()
{
  local -r expected="${1}"
  local -r type="${2}"
  local -r IMAGE_BASE_SHA=$(docker run --rm $(test_image_name)-${type} sh -c 'echo -n ${BASE_SHA}')

  if [ "${expected}" != "${IMAGE_BASE_SHA}" ]; then
    echo ERROR
    echo "BASE_SHA=${expected} from cyberdojo/start-points-base:latest"
    echo "BASE_SHA=${IMAGE_BASE_SHA} from $(test_image_name)-${type}"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_test_derived_images()
{
  readonly BASE_SHA=$(git_commit_sha)

  build_image_which_creates_test_data_git_repos

  build_test_custom_image
  assert_base_sha_equal "${BASE_SHA}" custom

  build_test_exercises_image
  assert_base_sha_equal "${BASE_SHA}" exercises

  build_test_languages_image
  assert_base_sha_equal "${BASE_SHA}" languages
}
