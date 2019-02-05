#!/bin/bash

test_custom_repo_contains_no_manifests()
{
  make_TMP_DIR_for_git_repos
  local C1_TMP_URL=$(git_repo_url_in_TMP_DIR_from custom-tennis)
  local C2_TMP_URL=$(git_repo_url_in_TMP_DIR_from custom_no_manifests)
  local E1_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises-bowling-game)
  local L1_TMP_URL=$(git_repo_url_in_TMP_DIR_from ltf-python-unittest)

  local image_name="${FUNCNAME[0]}"
  build_start_points_image \
    "${image_name}"        \
      --custom             \
        "${C1_TMP_URL}"    \
        "${C2_TMP_URL}"    \
      --exercises          \
        "${E1_TMP_URL}"    \
      --languages          \
        "${L1_TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: no manifest.json files in"
  assert_stderr_includes "--custom ${E2_TMP_URL}"
  assert_stderr_line_count_equals 2
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_exercises_repo_contains_no_manifests()
{
  make_TMP_DIR_for_git_repos
  local C1_TMP_URL=$(git_repo_url_in_TMP_DIR_from custom-tennis)
  local E1_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises-bowling-game)
  local E2_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_no_manifests)
  local L1_TMP_URL=$(git_repo_url_in_TMP_DIR_from ltf-python-unittest)

  local image_name="${FUNCNAME[0]}"
  build_start_points_image \
    "${image_name}"        \
      --custom             \
        "${C1_TMP_URL}"    \
      --exercises          \
        "${E1_TMP_URL}"    \
        "${E2_TMP_URL}"    \
      --languages          \
        "${L1_TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: no manifest.json files in"
  assert_stderr_includes "--exercises ${E2_TMP_URL}"
  assert_stderr_line_count_equals 2
  #assert_status_equals 9
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_languages_repo_contains_no_manifests()
{
  make_TMP_DIR_for_git_repos
  local C1_TMP_URL=$(git_repo_url_in_TMP_DIR_from custom-tennis)
  local E1_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises-bowling-game)
  local L1_TMP_URL=$(git_repo_url_in_TMP_DIR_from ltf-python-unittest)
  local L2_TMP_URL=$(git_repo_url_in_TMP_DIR_from ltf_no_manifests)

  local image_name="${FUNCNAME[0]}"
  build_start_points_image \
    "${image_name}"        \
      --custom             \
        "${C1_TMP_URL}"    \
      --exercises          \
        "${E1_TMP_URL}"    \
      --languages          \
        "${L1_TMP_URL}"    \
        "${L2_TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: no manifest.json files in"
  assert_stderr_includes "--languages ${L2_TMP_URL}"
  assert_stderr_line_count_equals 2
  #assert_status_equals 9
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
