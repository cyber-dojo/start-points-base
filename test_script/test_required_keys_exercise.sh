#!/bin/bash

readonly error_code=51

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_no_display_name()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_missing_display_name)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  assert_stderr_includes 'ERROR: missing required key "display_name"'
  assert_stderr_includes "--exercises ${tmp_url}"
  assert_stderr_includes "manifest='exercises-fizz-buzz/manifest.json'"
  assert_stderr_line_count_equals 3
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
