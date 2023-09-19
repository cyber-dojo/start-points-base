#!/usr/bin/env bash

readonly error_code=16

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_custom()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from custom_no_manifests)

  build_start_points_image_custom "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: no manifest.json files in"
    "--custom ${tmp_url}"
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_exercises()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_no_manifests)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: no manifest.json files in"
    "--exercises ${tmp_url}"
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_languages()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_no_manifests)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: no manifest.json files in"
    "--languages ${tmp_url}"
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
