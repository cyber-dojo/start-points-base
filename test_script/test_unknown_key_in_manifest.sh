#!/bin/bash

test_language_repo_manifest_contains_unknown_key()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_unknown_key)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: unknown key in manifest.json file"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "filename='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes 'key="Display_name"'
  assert_stderr_line_count_equals 4
  assert_status_equals 19
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
