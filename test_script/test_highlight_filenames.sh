#!/bin/bash -Eeu

readonly error_code=43

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_success()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_highlight_filenames_success)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_highlight_filenames_int)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: highlight_filenames must be an Array of Strings"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"highlight_filenames": 42'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int_array()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_highlight_filenames_int_array)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: highlight_filenames must be an Array of Strings"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"highlight_filenames": [42]'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty_array()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_highlight_filenames_empty_array)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: highlight_filenames must be an Array of Strings"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"highlight_filenames": []'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_highlight_filenames_empty_string)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: highlight_filenames must be an Array of Strings"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"highlight_filenames": [""]'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_not_visible()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_highlight_filenames_not_visible)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: highlight_filenames[1]=\"xx.cs\" not in visible_filenames"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"highlight_filenames": ["Hiker.cs", "xx.cs"]'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_duplicates()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_highlight_filenames_duplicates)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: highlight_filenames[0, 2] are duplicates of \"Hiker.cs\""
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"highlight_filenames": ["Hiker.cs", "HikerTest.cs", "Hiker.cs"]'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
