#!/usr/bin/env bash

readonly error_code=51

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_no_display_name()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r tmp_url=$(git_repo_url_in_TMP_DIR_from exercises_manifest_missing_display_name)

  build_start_points_image_exercises "${image_name}" "${tmp_url}"

  refute_image_created
  local -r expected=(
    'ERROR: missing required key "display_name"'
    "--exercises ${tmp_url}"
    "manifest='exercises-fizz-buzz/manifest.json'"
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
