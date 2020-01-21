#!/bin/bash -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_one_git_repo()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r L_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-csharp-nunit)

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
  local -r image_name="${FUNCNAME[0]}"
  local -r L1_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-csharp-nunit)
  local -r L2_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-ruby-minitest)

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
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
