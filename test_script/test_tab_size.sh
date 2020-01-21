#!/bin/bash -Eeu

readonly error_code=41

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_success_smallest_int()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_tab_size_smallest_int)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_success_biggest_int()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_tab_size_biggest_int)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_tab_size_string)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: tab_size must be an Integer"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"tab_size": "6"'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int_too_small()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_tab_size_int_too_small)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: tab_size must be an Integer (1..8)"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"tab_size": 0'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int_too_large()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_tab_size_int_too_large)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: tab_size must be an Integer (1..8)"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"tab_size": 9'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
