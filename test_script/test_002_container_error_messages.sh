#!/bin/bash
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh

test_002a_custom_repo_contains_no_manifests()
{
  make_TMP_DIR_for_git_repos
  local C_TMP_DIR=$(create_git_repo_in_TMP_DIR_from_data_set custom_repo_contains_no_manifests)
  local E_TMP_DIR=$(create_git_repo_in_TMP_DIR_from_data_set good_exercises)
  local L_TMP_DIR=$(create_git_repo_in_TMP_DIR_from_data_set good_languages)

  local image_name="${FUNCNAME[0]}"
  build_start_points_image \
    "${image_name}"  \
      --custom    "file://${C_TMP_DIR}" \
      --exercises "file://${E_TMP_DIR}" \
      --languages "file://${L_TMP_DIR}"

  docker image rm "${image_name}" > /dev/null # not working yet...
  refute_image_created
  assert_stdout_includes $(echo -e "--custom \t file://${C_TMP_DIR}")
  assert_stdout_includes $(echo -e "--exercises \t file://${E_TMP_DIR}")
  assert_stdout_includes $(echo -e "--languages \t file://${L_TMP_DIR}")
  #assert_stdout_line_count_equals 3

  #assert_stdout_equals ''
  #assert_stderr_equals 'ERROR: --custom requires at least one <git-repo-url>'
  #assert_status_equals 9
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
