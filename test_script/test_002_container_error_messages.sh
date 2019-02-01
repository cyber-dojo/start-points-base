#!/bin/bash
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh

test_002a_custom_repo_contains_no_manifests()
{
  make_TMP_DIR_for_git_repos
  create_git_repo_in_TMP_DIR_from_data_set custom_repo_contains_no_manifests
  create_git_repo_in_TMP_DIR_from_data_set good_exercises
  create_git_repo_in_TMP_DIR_from_data_set good_languages

  local image_name="${FUNCNAME[0]}"
  build_start_points_image \
    "${image_name}"  \
      --custom    "file://${TMP_DIR}/custom_repo_contains_no_manifests" \
      --exercises "file://${TMP_DIR}/good_exercises" \
      --languages "file://${TMP_DIR}/good_languages"

  docker image rm "${image_name}" > /dev/null
  refute_image_created
  assert_stdout_includes $(echo -e "--custom \t file://${TMP_DIR}/custom_repo_contains_no_manifests")
  assert_stdout_includes $(echo -e "--exercises \t file://${TMP_DIR}/good_exercises")
  assert_stdout_includes $(echo -e "--languages \t file://${TMP_DIR}/good_languages")

  #assert_stdout_equals ''
  #assert_stderr_equals 'ERROR: --custom requires at least one <git-repo-url>'
  #assert_status_equals 9
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
