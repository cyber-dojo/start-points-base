#!/usr/bin/env bash

readonly error_code=90

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_duplicates()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r TMP_URL_1=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_display_names_duplicate_1)
  local -r TMP_URL_2=$(git_repo_url_in_TMP_DIR_from exercises_manifest_has_display_names_duplicate_2)

  build_start_points_image "${image_name}" \
    --exercises \
      "${TMP_URL_1}" \
      "${TMP_URL_2}"

  refute_image_created
  local -r expected=(
    "ERROR: display_name duplicate"
    "--exercises ${TMP_URL_1}"
    "manifest='exercises-fizz-buzz/manifest.json'"
    '"display_name": "Dup"'
    "--exercises ${TMP_URL_2}"
    "manifest='exercises-tiny-maze/manifest.json'"
    '"display_name": "Dup"'
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
