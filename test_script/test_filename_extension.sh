#!/bin/bash

test_language_repo_manifest_contains_non_string_filename_extension()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_has_non_string_filename_extension)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: filename_extension must be a String or Array of Strings"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_includes '"filename_extension": 1'
  assert_stderr_line_count_equals 4
  assert_status_equals 34
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
