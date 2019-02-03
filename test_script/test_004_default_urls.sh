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

  local default_custom='https://github.com/cyber-dojo/start-points-custom.git'
  assert_stdout_includes $(echo -e "--custom \t ${default_custom}")
  assert_stdout_includes $(echo -e "--exercises \t file://${E_TMP_DIR}")
  assert_stdout_includes $(echo -e "--languages \t file://${L_TMP_DIR}")
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

  local default_exercises='https://github.com/cyber-dojo/start-points-exercises.git'
  assert_stdout_includes $(echo -e "--custom \t ${C_TMP_DIR}")
  assert_stdout_includes $(echo -e "--exercises \t file://${default_exercises}")
  assert_stdout_includes $(echo -e "--languages \t file://${L_TMP_DIR}")
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

  local default_languages_1='https://github.com/cyber-dojo-languages/csharp-nunit'
  local default_languages_2='https://github.com/cyber-dojo-languages/gcc-googletest'
  local default_languages_3='https://github.com/cyber-dojo-languages/gplusplus-googlemock'
  local default_languages_4='https://github.com/cyber-dojo-languages/java-junit'
  local default_languages_5='https://github.com/cyber-dojo-languages/javascript-jasmine'
  local default_languages_6='https://github.com/cyber-dojo-languages/python-pytest'
  local default_languages_7='https://github.com/cyber-dojo-languages/ruby-minitest'

  assert_stdout_includes $(echo -e "--custom \t ${C_TMP_DIR}")
  assert_stdout_includes $(echo -e "--exercises \t file://${E_TMP_DIR}")
  assert_stdout_includes $(echo -e "--languages \t file://${default_languages_1}")
  assert_stdout_includes $(echo -e "--languages \t file://${default_languages_2}")
  assert_stdout_includes $(echo -e "--languages \t file://${default_languages_3}")
  assert_stdout_includes $(echo -e "--languages \t file://${default_languages_4}")
  assert_stdout_includes $(echo -e "--languages \t file://${default_languages_5}")
  assert_stdout_includes $(echo -e "--languages \t file://${default_languages_6}")
  assert_stdout_includes $(echo -e "--languages \t file://${default_languages_7}")
  assert_stdout_line_count_equals 9

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
