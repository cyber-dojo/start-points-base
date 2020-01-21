#!/bin/bash -Eeu

readonly error_code=33

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_success()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages-csharp-nunit)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_int)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension must be a String or Array of Strings"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": 1'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int_array()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_int_array)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension must be a String or Array of Strings"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": [1, 2, 3]'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty_array()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_empty_array)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension must be a String or Array of Strings"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": []'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_empty_string)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension[0]='' cannot be empty String"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": [""]'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_doesnt_start_dot()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_dotless)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension[0]=\"cs\" must start with a dot"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": ["cs"]'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_only_a_dot()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_is_only_dot)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension[0]=\".\" must be more than just a dot"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": ["."]'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_duplicates()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_filename_extension_duplicates)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension[1, 3] are duplicates of \".h\""
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": [".cs", ".h", ".c", ".h"]'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
