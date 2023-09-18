#!/usr/bin/env bash

readonly error_code=32

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_non_array_visible_filenames)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes "ERROR: visible_filenames is not an Array"
  assert_stdout_includes "--languages ${tmp_url}"
  assert_stdout_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stdout_includes '"visible_filenames": 1'
  # assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_empty_visible_filenames)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes "ERROR: visible_filenames cannot be empty"
  assert_stdout_includes "--languages ${tmp_url}"
  assert_stdout_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stdout_includes '"visible_filenames": []'
  # assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_array_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_non_array_string_visible_filenames)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes "ERROR: visible_filenames[0]=1 is not a String"
  assert_stdout_includes "--languages ${tmp_url}"
  assert_stdout_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stdout_includes '"visible_filenames": [1, "cyber-dojo.sh"]'
  # assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_empty_string_visible_filename)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes "ERROR: visible_filenames[1]='' cannot be empty String"
  assert_stdout_includes "--languages ${tmp_url}"
  assert_stdout_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stdout_includes '"visible_filenames": ["cyber-dojo.sh", ""]'
  # assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_portable_character()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_visible_filename_has_non_portable_character)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes "ERROR: visible_filenames[1]=\"hiker&.cs\" has non-portable character '&'"
  assert_stdout_includes "--languages ${tmp_url}"
  assert_stdout_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stdout_includes '"visible_filenames": ["cyber-dojo.sh", "hiker&.cs"]'
  # assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_portable_leading_character()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_visible_filename_has_non_portable_leading_character)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes "ERROR: visible_filenames[0]=\"-hiker.cs\" has non-portable leading character '-'"
  assert_stdout_includes "--languages ${tmp_url}"
  assert_stdout_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stdout_includes '"visible_filenames": ["-hiker.cs", "cyber-dojo.sh"]'
  # assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_duplicates()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_visible_filename_has_duplicates)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes 'ERROR: visible_filenames[0, 1] are duplicates of "cyber-dojo.sh"'
  assert_stdout_includes "--languages ${tmp_url}"
  assert_stdout_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stdout_includes '"visible_filenames": ["cyber-dojo.sh", "cyber-dojo.sh"]'
  # assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_does_not_exist()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_visible_filename_does_not_exist)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes 'ERROR: visible_filenames[1]="xHiker.cs" does not exist'
  assert_stdout_includes "--languages ${tmp_url}"
  assert_stdout_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stdout_includes '"visible_filenames": ["HikerTest.cs", "xHiker.cs", "cyber-dojo.sh"]'
  # assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_no_cyber_dojo_sh()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_visible_filename_no_cyber_dojo_sh)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes 'ERROR: visible_filenames does not include "cyber-dojo.sh"'
  assert_stdout_includes "--languages ${tmp_url}"
  assert_stdout_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stdout_includes '"visible_filenames": ["HikerTest.cs", "Hiker.cs"]'
  # assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_file_too_large()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_visible_file_too_large)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes 'ERROR: visible_filenames[1]="large.cs" is too large (>25K)'
  assert_stdout_includes "--languages ${tmp_url}"
  assert_stdout_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stdout_includes '"visible_filenames": ["tiny.cs", "large.cs", "small.cs", "cyber-dojo.sh"]'
  # assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
