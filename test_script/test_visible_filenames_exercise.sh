#!/bin/bash

test_failure_non_string()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_non_array_visible_filenames)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: visible_filenames is not an Array"
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"visible_filenames": 1'
  assert_stderr_line_count_equals 4
  assert_status_equals 61
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_empty()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_empty_visible_filenames)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: visible_filenames cannot be empty"
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"visible_filenames": []'
  assert_stderr_line_count_equals 4
  assert_status_equals 61
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_non_array_string()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_non_array_string_visible_filenames)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: visible_filenames[0]=1 is not a String"
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"visible_filenames": [1]'
  assert_stderr_line_count_equals 4
  assert_status_equals 61
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_empty_string()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_empty_string_visible_filename)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: visible_filenames[0]='' cannot be empty String"
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"visible_filenames": [""]'
  assert_stderr_line_count_equals 4
  assert_status_equals 61
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_non_portable_character()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_filename_has_non_portable_character)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: visible_filenames[1]=\"hiker&.txt\" has non-portable character '&'"
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"visible_filenames": ["instructions", "hiker&.txt"]'
  assert_stderr_line_count_equals 4
  assert_status_equals 61
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_non_portable_leading_character()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_filename_has_non_portable_leading_character)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: visible_filenames[0]=\"-hiker.txt\" has non-portable leading character '-'"
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"visible_filenames": ["-hiker.txt", "instructions"]'
  assert_stderr_line_count_equals 4
  assert_status_equals 61
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_duplicates()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_filename_has_duplicates)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes 'ERROR: visible_filenames[0, 1] are duplicates of "instructions"'
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"visible_filenames": ["instructions", "instructions"]'
  assert_stderr_line_count_equals 4
  assert_status_equals 61
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_does_not_exist()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_filename_does_not_exist)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes 'ERROR: visible_filenames[1]="HikerTest.txt" does not exist'
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"visible_filenames": ["instructions", "HikerTest.txt"]'
  assert_stderr_line_count_equals 4
  assert_status_equals 61
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_has_cyber_dojo_sh()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_filename_has_cyber_dojo_sh)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes 'ERROR: visible_filenames cannot include "cyber-dojo.sh"'
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"visible_filenames": ["instructions", "cyber-dojo.sh"]'
  assert_stderr_line_count_equals 4
  assert_status_equals 61
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_failure_file_too_large()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_file_too_large)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes 'ERROR: visible_filenames[1]="large.txt" is too large (>25K)'
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_includes '"visible_filenames": ["tiny.txt", "large.txt", "small.txt"]'
  assert_stderr_line_count_equals 4
  assert_status_equals 61
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
