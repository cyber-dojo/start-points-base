#!/usr/bin/env bash

readonly error_code=50

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_unknown_key()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercise_manifest_has_unknown_key)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stdout_includes 'ERROR: unknown key "Display_name"'
  assert_stdout_includes "--exercises ${tmp_url}"
  assert_stdout_includes "manifest='exercises-fizz-buzz/manifest.json'"
  # assert_stderr_line_count_equals 3
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
