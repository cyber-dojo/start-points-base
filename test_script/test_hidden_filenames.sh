#!/usr/bin/env bash

readonly error_code=40

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_success()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_hidden_filenames_success)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  assert_image_created
  assert_stderr_empty
  assert_status_0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_success_empty_array()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_hidden_filenames_empty_array)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  assert_image_created
  assert_stderr_empty
  assert_status_0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_hidden_filenames_int)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: hidden_filenames must be an Array of Strings"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"hidden_filenames": 1'
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int_array()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_hidden_filenames_int_array)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: hidden_filenames must be an Array of Strings"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"hidden_filenames": [1, 2, 3]'
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_hidden_filenames_empty_string)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: hidden_filenames must be an Array of Strings"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"hidden_filenames": [""]'
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_bad_regex()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_hidden_filenames_bad_regex)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    'ERROR: hidden_filenames[0]="(" cannot create Regexp'
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"hidden_filenames": ["("]'
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_duplicates()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_hidden_filenames_duplicate)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    'ERROR: hidden_filenames[0, 2] are duplicates of "sd"'
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"hidden_filenames": ["sd", "gg", "sd"]'
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
