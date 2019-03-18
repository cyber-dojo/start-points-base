#!/bin/bash

echo "::${0##*/}"

test_one_git_repo()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local L_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-csharp-nunit)

  build_start_points_image       \
    "${image_name}"              \
      --languages "${L_TMP_URL}"

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_more_than_one_git_repo()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local L1_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-csharp-nunit)
  local L2_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-ruby-minitest)

  build_start_points_image \
    "${image_name}"        \
      --languages          \
        "${L1_TMP_URL}"    \
        "${L2_TMP_URL}"

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
