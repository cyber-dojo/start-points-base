#!/bin/bash
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh

test_002a_custom_repo_contains_no_manifests()
{
  local image_name="${FUNCNAME[0]}"
  TMP_DIR=$(make_TMP_DIR_for_git_repos)

  create_git_repo_in_TMP_DIR_from_data_set custom_repo_contains_no_manifests
  create_git_repo_in_TMP_DIR_from_data_set good_exercises
  create_git_repo_in_TMP_DIR_from_data_set good_languages

  build_start_points_image \
    "${image_name}"  \
      --custom    "file://${TMP_DIR}/custom_repo_contains_no_manifests" \
      --exercises "file://${TMP_DIR}/good_exercises" \
      --languages "file://${TMP_DIR}/good_languages"

  #assert_stdout_equals ''
  #assert_stderr_equals 'ERROR: --custom requires at least one <git-repo-url>'
  #assert_status_equals 9
  docker image rm "${image_name}"
  refute_image_created "${image_name}"
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
