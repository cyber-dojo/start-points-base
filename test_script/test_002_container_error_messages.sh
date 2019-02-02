#!/bin/bash
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh

test_002a_custom_repo_contains_no_manifests()
{
  make_TMP_DIR_for_git_repos
  local C1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from custom-Tennis)
  local C2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from custom-Yahtzee)
  local E1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-bowling-game)
  local E2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-tiny-maze)
  local L1_TMP_DIR=$(create_git_repo_in_TMP_DIR_from ltf-python-unittest)
  local L2_TMP_DIR=$(create_git_repo_in_TMP_DIR_from ltf_no_manifests)

  local image_name="${FUNCNAME[0]}"
  build_start_points_image     \
    "${image_name}"            \
      --custom                 \
        "file://${C1_TMP_DIR}" \
        "file://${C2_TMP_DIR}" \
      --exercises              \
        "file://${E1_TMP_DIR}" \
        "file://${E2_TMP_DIR}" \
      --languages              \
        "file://${L1_TMP_DIR}" \
        "file://${L2_TMP_DIR}"

  refute_image_created
  assert_stdout_includes $(echo -e "--custom \t file://${C1_TMP_DIR}")
  assert_stdout_includes $(echo -e "--custom \t file://${C2_TMP_DIR}")
  assert_stdout_includes $(echo -e "--exercises \t file://${E1_TMP_DIR}")
  assert_stdout_includes $(echo -e "--exercises \t file://${E2_TMP_DIR}")
  assert_stdout_includes $(echo -e "--languages \t file://${L1_TMP_DIR}")
  assert_stdout_includes $(echo -e "--languages \t file://${L2_TMP_DIR}")
  #assert_stdout_line_count_equals 6

  #dump_sss
  assert_stderr_includes "ERROR: no manifest.json files"
  assert_stderr_includes "--languages file://${L2_TMP_DIR}"
  #assert_stderr_line_count_equals 2
  #assert_status_equals 9
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
