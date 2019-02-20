#!/bin/bash

test_failure_non_string()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_non_string_display_name)

  build_start_points_image_languages "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: display_name is not a String"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"display_name": [1, 2, 3]'
  assert_stderr_line_count_equals 4
  assert_status_equals 31
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_empty_string()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_empty_display_name)

  build_start_points_image_languages "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: display_name is empty"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"display_name": ""'
  assert_stderr_line_count_equals 4
  assert_status_equals 31
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
