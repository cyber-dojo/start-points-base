#!/bin/bash
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh

test_003a_simple_success_case()
{
  make_TMP_DIR_for_git_repos
  local C_TMP_DIR=$(create_git_repo_in_TMP_DIR_from good_custom)
  local E_TMP_DIR=$(create_git_repo_in_TMP_DIR_from good_exercises)
  local L1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from ltf-csharp-nunit)
  local L2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from ltf-ruby-minitest)

  local image_name="${FUNCNAME[0]}"
  build_start_points_image     \
    "${image_name}"            \
      --custom                 \
        "file://${C_TMP_DIR}"  \
      --exercises              \
        "file://${E_TMP_DIR}"  \
      --languages              \
        "file://${L1_TMP_DIR}" \
        "file://${L2_TMP_DIR}"

  assert_image_created
  assert_stdout_includes $(echo -e "--custom \t file://${C_TMP_DIR}")
  assert_stdout_includes $(echo -e "--exercises \t file://${E_TMP_DIR}")
  assert_stdout_includes $(echo -e "--languages \t file://${L1_TMP_DIR}")
  assert_stdout_includes $(echo -e "--languages \t file://${L2_TMP_DIR}")
  assert_stdout_line_count_equals 4

  assert_stderr_equals ''
  assert_status_equals 0
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
