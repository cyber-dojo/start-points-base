#!/usr/bin/env bash

readonly error_code=18

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_language()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_duplicate_keys)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: duplicate keys in manifest.json file"
    "--languages ${tmp_url}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '{'
    '  "display_name": "C#, NUnit",'
    '  "display_name": "C#, JUnit"'
    '}'
  )
  assert_diagnostic_is "${expected[@]}"
  # assert_status_equals "${error_code}"  # TODO
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_exercise()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_duplicate_keys)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    "ERROR: duplicate keys in manifest.json file"
    "--exercises ${tmp_url}"
    "manifest='exercises-leap-years/manifest.json'"
    '{'
    '  "display_name": "Leap Years",'
    '  "display_name": "Years Leap"'
    '}'
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
