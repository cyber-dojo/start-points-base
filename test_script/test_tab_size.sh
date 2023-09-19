#!/usr/bin/env bash

readonly error_code=41

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_success_smallest_int()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_tab_size_smallest_int)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  assert_image_created
  assert_stderr_empty
  assert_status_0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_success_biggest_int()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_tab_size_biggest_int)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  assert_image_created
  assert_stderr_empty
  assert_status_0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_tab_size_string)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: tab_size must be an Integer"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"tab_size": "6"'
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int_too_small()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_tab_size_int_too_small)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: tab_size must be an Integer (1..8)"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"tab_size": 0'
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_int_too_large()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_tab_size_int_too_large)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: tab_size must be an Integer (1..8)"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"tab_size": 9'
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
