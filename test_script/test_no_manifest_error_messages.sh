#!/bin/bash

test_custom_repo_contains_no_manifests()
{
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from custom_no_manifests)
  local image_name="${FUNCNAME[0]}"

  build_start_points_image_custom_error \
    "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: no manifest.json files in"
  assert_stderr_includes "--custom ${TMP_URL}"
  assert_stderr_line_count_equals 2
  assert_status_equals 16
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_exercises_repo_contains_no_manifests()
{
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_no_manifests)
  local image_name="${FUNCNAME[0]}"

  build_start_points_image_exercises_error \
    "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: no manifest.json files in"
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_line_count_equals 2
  assert_status_equals 16
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_languages_repo_contains_no_manifests()
{
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_no_manifests)
  local image_name="${FUNCNAME[0]}"

  build_start_points_image_languages_error \
    "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: no manifest.json files in"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_line_count_equals 2
  assert_status_equals 16
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
