#!/usr/bin/env bash

readonly error_code=16

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_custom()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from custom_no_manifests)

  build_start_points_image_custom "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes "ERROR: no manifest.json files in"
  assert_stdout_includes "--custom ${tmp_url}"
  # assert_stderr_line_count_equals 2
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_exercises()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_no_manifests)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes "ERROR: no manifest.json files in"
  assert_stdout_includes "--exercises ${tmp_url}"
  # assert_stderr_line_count_equals 2
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_languages()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from languages_no_manifests)

  build_start_points_image_languages "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes "ERROR: no manifest.json files in"
  assert_stdout_includes "--languages ${tmp_url}"
  # assert_stderr_line_count_equals 2
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
