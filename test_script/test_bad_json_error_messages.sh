#!/bin/bash

test_language_repo_manifest_contains_bad_json()
{
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from ltf_bad_json)
  local image_name="${FUNCNAME[0]}"

  build_start_points_image_languages_error \
    "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: bad JSON in manifest.json file"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "filename='/app/repos/languages/3/ltf-python-unittest/start_point/manifest.json'"
  assert_stderr_includes "765: unexpected token at 'sdfsdf'"
  assert_stderr_line_count_equals 4
  assert_status_equals 17
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_exercise_repo_manifest_contains_bad_json()
{
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_bad_json)
  local image_name="${FUNCNAME[0]}"

  build_start_points_image_exercises_error \
    "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: bad JSON in manifest.json file"
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "filename='/app/repos/exercises/2/exercises-bowling-game/manifest.json'"
  assert_stderr_includes "765: unexpected token at 'ggghhhjjj'"
  assert_stderr_line_count_equals 4
  assert_status_equals 17
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2