#!/usr/bin/env bash

readonly error_code=44

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_success()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_success)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  assert_image_created
  assert_stderr_empty
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_int)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: progress_regexs must be an Array of 2 Strings"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"progress_regexs": 6'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_string)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: progress_regexs must be an Array of 2 Strings"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"progress_regexs": "6"'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int_array()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_int_array)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: progress_regexs must be an Array of 2 Strings"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"progress_regexs": [1, 2]'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty_array()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_empty_array)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: progress_regexs must be an Array of 2 Strings"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"progress_regexs": []'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_bad_regex()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_progress_regexs_bad_regex)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    'ERROR: progress_regexs[1]="(" cannot create Regexp'
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"progress_regexs": ["OK", "("]'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
