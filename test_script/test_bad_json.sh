#!/bin/bash

test_language_manifest()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from languages_bad_json)

  build_start_points_image_languages "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: bad JSON in manifest.json file"
  assert_stderr_includes "--languages ${TMP_URL}"
  assert_stderr_includes "manifest='languages-python-unittest/start_point/manifest.json'"
  assert_stderr_includes "765: unexpected token at 'sdfsdf'"
  assert_stderr_line_count_equals 4
  assert_status_equals 17
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_exercise_manifest()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises_bad_json)

  build_start_points_image_exercises "${image_name}" "${TMP_URL}"

  refute_image_created
  assert_stderr_includes "ERROR: bad JSON in manifest.json file"
  assert_stderr_includes "--exercises ${TMP_URL}"
  assert_stderr_includes "manifest='exercises-bowling-game/manifest.json'"
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
