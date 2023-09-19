#!/usr/bin/env bash

readonly error_code=31

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_non_string_display_name)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: display_name is not a String"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"display_name": [1, 2, 3]'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_empty_display_name)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: display_name cannot be empty String"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"display_name": ""'
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
