#!/usr/bin/env bash

readonly error_code=60

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_non_string_display_name)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: display_name is not a String"
    "--exercises ${tmp_url}"
    "manifest='exercises-fizz-buzz/manifest.json'"
    '"display_name": [1, 2, 3]'
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_empty_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_empty_display_name)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: display_name cannot be empty String"
    "--exercises ${tmp_url}"
    "manifest='exercises-fizz-buzz/manifest.json'"
    '"display_name": ""'
  )
  # assert_status_equals "${error_code}" # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
