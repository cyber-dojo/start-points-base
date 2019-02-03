#!/bin/bash

echo "::${0##*/}"

test_git_must_be_installed()
{
  export GIT_PROGRAM='git_xxx'
  local image_name="${FUNCNAME[0]}"
  build_start_points_image "${image_name}"
  unset GIT_PROGRAM
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: git is not installed!'
  assert_status_equals 1
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_docker_must_be_installed()
{
  export DOCKER_PROGRAM='docker_xxx'
  local image_name="${FUNCNAME[0]}"
  build_start_points_image "${image_name}"
  unset DOCKER_PROGRAM
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: docker is not installed!'
  assert_status_equals 2
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_custom_option_requires_image_name()
{
  build_start_points_image --custom
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --custom requires preceding <image_name>'
  assert_status_equals 4
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_exercises_option_requires_image_name()
{
  build_start_points_image --exercises
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --exercises requires preceding <image_name>'
  assert_status_equals 5
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_languages_option_requires_image_name()
{
  build_start_points_image --languages
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --languages requires preceding <image_name>'
  assert_status_equals 6
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_git_repo_url_requires_preceding_custom_or_exercises_or_languages()
{
  local image_name="${FUNCNAME[0]}"
  local git_repo_url=file://a/b/c
  build_start_points_image "${image_name}" "${git_repo_url}"
  assert_stdout_equals ''
  assert_stderr_equals "ERROR: <git-repo-url> ${git_repo_url} without preceding --custom/--exercises/--languages"
  assert_status_equals 6
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_custom_option_requires_at_least_one_following_git_repo_url()
{
  local image_name="${FUNCNAME[0]}"
  build_start_points_image "${image_name}" --custom
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --custom requires at least one <git-repo-url>'
  assert_status_equals 7
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_exercises_option_requires_at_least_one_following_git_repo_url()
{
  local image_name="${FUNCNAME[0]}"
  build_start_points_image "${image_name}" --exercises
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --exercises requires at least one <git-repo-url>'
  assert_status_equals 8
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_languages_option_requires_at_least_one_following_git_repo_url()
{
  local image_name="${FUNCNAME[0]}"
  build_start_points_image "${image_name}" --languages
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --languages requires at least one <git-repo-url>'
  assert_status_equals 9
  refute_image_created "${image_name}"
}

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
