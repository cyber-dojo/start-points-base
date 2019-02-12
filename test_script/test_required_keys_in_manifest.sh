#!/bin/bash

test_language_repo_manifest_missing_display_name()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_missing_display_name)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes 'ERROR: missing required key "display_name"'
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_line_count_equals 3
  assert_status_equals 20
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_language_repo_manifest_missing_visible_filanames()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_manifest_missing_visible_filenames)

  build_start_points_image_languages_error "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes 'ERROR: missing required key "visible_filenames"'
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-csharp-nunit/start_point/manifest.json'"
  assert_stderr_line_count_equals 3
  assert_status_equals 20
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
