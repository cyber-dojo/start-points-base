#!/usr/bin/env bash

readonly error_code=17

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_language_manifest()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_bad_json)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: bad JSON in manifest.json file"
    "--languages ${tmp_url}"
    "manifest='languages-python-unittest/start_point/manifest.json'"
    "unexpected token at 'sdfsdf'"
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_exercise_manifest()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_bad_json)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: bad JSON in manifest.json file"
    "--exercises ${tmp_url}"
    "manifest='exercises-bowling-game/manifest.json'"
    "unexpected token at 'ggghhhjjj'"
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
