#!/bin/bash

test_success()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_success)

  build_start_points_image_languages "${image_name}" "${TMP_URL}"

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_int()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_int)

  build_start_points_image_languages "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: progress_regexs must be an Array of 2 Strings"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"progress_regexs": 6'
  assert_stderr_line_count_equals 4
  assert_status_equals 44
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_string()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_string)

  build_start_points_image_languages "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: progress_regexs must be an Array of 2 Strings"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"progress_regexs": "6"'
  assert_stderr_line_count_equals 4
  assert_status_equals 44
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_int_array()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_int_array)

  build_start_points_image_languages "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: progress_regexs must be an Array of 2 Strings"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"progress_regexs": [1, 2]'
  assert_stderr_line_count_equals 4
  assert_status_equals 44
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_empty_array()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_empty_array)

  build_start_points_image_languages "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: progress_regexs must be an Array of 2 Strings"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"progress_regexs": []'
  assert_stderr_line_count_equals 4
  assert_status_equals 44
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_bad_regex()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_bad_regex)

  build_start_points_image_languages "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes 'ERROR: progress_regexs[1] cannot create Regexp'
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"progress_regexs": ["OK", "("]'
  assert_stderr_line_count_equals 4
  assert_status_equals 44
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
