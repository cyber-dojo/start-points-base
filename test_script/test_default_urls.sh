#!/bin/bash

echo "::${0##*/}"

test_default_custom_url()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local E_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises-bowling-game)
  local L_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-csharp-nunit)

  build_start_points_image       \
    "${image_name}"              \
      --exercises "${E_TMP_URL}" \
      --languages "${L_TMP_URL}"

  assert_stdout_includes_default_custom_url
  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_default_exercises_url()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local C_TMP_URL=$(git_repo_url_in_TMP_DIR_from custom-tennis)
  local L_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-csharp-nunit)

  build_start_points_image       \
    "${image_name}"              \
      --custom    "${C_TMP_URL}" \
      --languages "${L_TMP_URL}"

  assert_stdout_includes_default_exercises_url
  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_default_languages_urls()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local C_TMP_URL=$(git_repo_url_in_TMP_DIR_from custom-tennis)
  local E_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises-bowling-game)

  build_start_points_image       \
    "${image_name}"              \
      --custom    "${C_TMP_URL}" \
      --exercises "${E_TMP_URL}"

  assert_stdout_includes_default_languages_urls
  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_all_default_urls()
{
  local image_name="${FUNCNAME[0]}"

  build_start_points_image "${image_name}"

  assert_stdout_includes_default_custom_url
  assert_stdout_includes_default_exercises_url
  assert_stdout_includes_default_languages_urls
  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
