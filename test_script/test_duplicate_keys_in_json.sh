#!/bin/bash

readonly error_code=18

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_language()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_duplicate_keys)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: duplicate keys in manifest.json file"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '{'
  assert_stderr_includes '  "display_name": "C#, NUnit",'
  assert_stderr_includes '  "display_name": "C#, JUnit"'
  assert_stderr_includes '}'
  assert_stderr_line_count_equals 7
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_exercise()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_duplicate_keys)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: duplicate keys in manifest.json file"
  assert_stderr_includes "--exercises ${tmp_url}"
  assert_stderr_includes "manifest='exercises-leap-years/manifest.json'"
  assert_stderr_includes '{'
  assert_stderr_includes '  "display_name": "Leap Years",'
  assert_stderr_includes '  "display_name": "Years Leap"'
  assert_stderr_includes '}'
  assert_stderr_line_count_equals 7
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
