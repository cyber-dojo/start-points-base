#!/bin/bash -Eeu

readonly error_code=30

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_non_string()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_non_string_image_name)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: image_name is not a String"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"image_name": [1, 2, 3]'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_malformed()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_malformed_image_name)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes "ERROR: image_name is malformed"
  assert_stderr_includes "--languages ${tmp_url}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"image_name": "CYBERDOJO/csharp_nunit"'
  assert_stderr_line_count_equals 4
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
