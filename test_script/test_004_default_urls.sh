#!/bin/bash
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh

test_004a_default_custom_url()
{
  make_TMP_DIR_for_git_repos
  local E_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-bowling-game)
  local L_TMP_DIR=$(create_git_repo_in_TMP_DIR_from ltf-csharp-nunit)

  local image_name="${FUNCNAME[0]}"
  build_start_points_image     \
    "${image_name}"            \
      --exercises              \
        "file://${E_TMP_DIR}" \
      --languages              \
        "file://${L_TMP_DIR}"

  assert_stdout_includes_default_custom_url
  assert_stdout_line_count_equals 3

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_004b_default_exercises_url()
{
  make_TMP_DIR_for_git_repos
  local C_TMP_DIR=$(create_git_repo_in_TMP_DIR_from custom-tennis)
  local L_TMP_DIR=$(create_git_repo_in_TMP_DIR_from ltf-csharp-nunit)

  local image_name="${FUNCNAME[0]}"
  build_start_points_image     \
    "${image_name}"            \
      --custom                 \
        "file://${C_TMP_DIR}" \
      --languages              \
        "file://${L_TMP_DIR}"

  assert_stdout_includes_default_exercises_url
  assert_stdout_line_count_equals 3

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_004c_default_languages_urls()
{
  make_TMP_DIR_for_git_repos
  local C_TMP_DIR=$(create_git_repo_in_TMP_DIR_from custom-tennis)
  local E_TMP_DIR=$(create_git_repo_in_TMP_DIR_from exercises-bowling-game)

  local image_name="${FUNCNAME[0]}"
  build_start_points_image    \
    "${image_name}"           \
      --custom                \
        "file://${C_TMP_DIR}" \
      --exercises             \
        "file://${E_TMP_DIR}"

  assert_stdout_includes_default_languages_urls
  assert_stdout_line_count_equals 9

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_004d_all_default_urls()
{
  local image_name="${FUNCNAME[0]}"
  build_start_points_image \
    "${image_name}"

  assert_stdout_includes_default_custom_url
  assert_stdout_includes_default_exercises_url
  assert_stdout_includes_default_languages_urls

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_stdout_includes_default_custom_url()
{
  local default_custom='https://github.com/cyber-dojo/start-points-custom.git'
  assert_stdout_includes "$(echo -e "--custom \t ${default_custom}")"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_stdout_includes_default_exercises_url()
{
  local default_exercises='https://github.com/cyber-dojo/start-points-exercises.git'
  assert_stdout_includes "$(echo -e "--exercises \t ${default_exercises}")"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_stdout_includes_default_languages_urls()
{
  local default_languages=( \
    'https://github.com/cyber-dojo-languages/csharp-nunit' \
    'https://github.com/cyber-dojo-languages/gcc-googletest' \
    'https://github.com/cyber-dojo-languages/gplusplus-googlemock' \
    'https://github.com/cyber-dojo-languages/java-junit'\
    'https://github.com/cyber-dojo-languages/javascript-jasmine' \
    'https://github.com/cyber-dojo-languages/python-pytest' \
    'https://github.com/cyber-dojo-languages/ruby-minitest' \
  )
  for default_language in ${default_languages}; do
    assert_stdout_includes "$(echo -e "--languages \t ${default_language}")"
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
