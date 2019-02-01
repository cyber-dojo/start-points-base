#!/bin/bash
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh

test_003a_simple_success_case()
{
  make_TMP_DIR_for_git_repos
  create_git_repo_in_TMP_DIR_from_data_set good_custom
  create_git_repo_in_TMP_DIR_from_data_set good_exercises
  create_git_repo_in_TMP_DIR_from_data_set good_languages

  local image_name="${FUNCNAME[0]}"
  build_start_points_image \
    "${image_name}"  \
      --custom    "file://${TMP_DIR}/good_custom"    \
      --exercises "file://${TMP_DIR}/good_exercises" \
      --languages "file://${TMP_DIR}/good_languages"

  assert_image_created
  assert_stdout_includes $(echo -e "--custom \t file://${TMP_DIR}/good_custom")
  assert_stdout_includes $(echo -e "--exercises \t file://${TMP_DIR}/good_exercises")
  assert_stdout_includes $(echo -e "--languages \t file://${TMP_DIR}/good_languages")
  assert_stdout_line_count_equals 3

  assert_stderr_equals ''
  assert_status_equals 0
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
