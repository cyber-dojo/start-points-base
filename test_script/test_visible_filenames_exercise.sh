#!/usr/bin/env bash

readonly error_code=61

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_non_array_visible_filenames)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: visible_filenames is not an Array"
    "--exercises ${tmp_url}"
    "manifest='exercises-fizz-buzz/manifest.json'"
    '"visible_filenames": 1'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_empty_visible_filenames)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: visible_filenames cannot be empty"
    "--exercises ${tmp_url}"
    "manifest='exercises-fizz-buzz/manifest.json'"
    '"visible_filenames": []'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_array_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_non_array_string_visible_filenames)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
  "ERROR: visible_filenames[0]=1 is not a String"
  "--exercises ${tmp_url}"
  "manifest='exercises-fizz-buzz/manifest.json'"
  '"visible_filenames": [1]'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_empty_string_visible_filename)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
  "ERROR: visible_filenames[0]='' cannot be empty String"
  "--exercises ${tmp_url}"
  "manifest='exercises-fizz-buzz/manifest.json'"
  '"visible_filenames": [""]'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_portable_character()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_filename_has_non_portable_character)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: visible_filenames[1]=\"hiker&.txt\" has non-portable character '&'"
    "--exercises ${tmp_url}"
    "manifest='exercises-fizz-buzz/manifest.json'"
    '"visible_filenames": ["instructions", "hiker&.txt"]'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_portable_leading_character()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_filename_has_non_portable_leading_character)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: visible_filenames[0]=\"-hiker.txt\" has non-portable leading character '-'"
    "--exercises ${tmp_url}"
    "manifest='exercises-fizz-buzz/manifest.json'"
    '"visible_filenames": ["-hiker.txt", "instructions"]'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_duplicates()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_filename_has_duplicates)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    'ERROR: visible_filenames[0, 1] are duplicates of "instructions"'
    "--exercises ${tmp_url}"
    "manifest='exercises-fizz-buzz/manifest.json'"
    '"visible_filenames": ["instructions", "instructions"]'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_does_not_exist()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_filename_does_not_exist)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    'ERROR: visible_filenames[1]="HikerTest.txt" does not exist'
    "--exercises ${tmp_url}"
    "manifest='exercises-fizz-buzz/manifest.json'"
    '"visible_filenames": ["instructions", "HikerTest.txt"]'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_has_cyber_dojo_sh()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_filename_has_cyber_dojo_sh)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    'ERROR: visible_filenames cannot include "cyber-dojo.sh"'
    "--exercises ${tmp_url}"
    "manifest='exercises-fizz-buzz/manifest.json'"
    '"visible_filenames": ["instructions", "cyber-dojo.sh"]'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_file_too_large()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_visible_file_too_large)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
  'ERROR: visible_filenames[1]="large.txt" is too large (>25K)'
  "--exercises ${tmp_url}"
  "manifest='exercises-fizz-buzz/manifest.json'"
  '"visible_filenames": ["tiny.txt", "large.txt", "small.txt"]'
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
