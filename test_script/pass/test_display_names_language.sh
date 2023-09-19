#!/usr/bin/env bash

readonly error_code=40

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_failure_duplicates()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r TMP_URL_1=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_display_names_duplicate_1)
  local -r TMP_URL_2=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_display_names_duplicate_2)

  build_start_points_image "${image_name}" \
    --languages \
      "${TMP_URL_1}" \
      "${TMP_URL_2}"

  refute_image_created
  local -r expected=(
    "ERROR: display_name duplicate"
    "--languages ${TMP_URL_1}"
    "manifest='languages-csharp-nunit/start_point/manifest.json'"
    '"display_name": "Dup"'
    "--languages ${TMP_URL_2}"
    "manifest='languages-python-unittest/start_point/manifest.json'"
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
