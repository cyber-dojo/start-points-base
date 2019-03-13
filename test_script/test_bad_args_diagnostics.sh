#!/bin/bash

echo "::${0##*/}"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_custom_option_requires_image_name()
{
  build_start_points_image --custom

  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --custom requires preceding <image_name>'
  assert_status_equals 4
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_exercises_option_requires_image_name()
{
  build_start_points_image --exercises

  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --exercises requires preceding <image_name>'
  assert_status_equals 5
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_languages_option_requires_image_name()
{
  build_start_points_image --languages

  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --languages requires preceding <image_name>'
  assert_status_equals 6
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_git_repo_url_requires_preceding_custom_or_exercises_or_languages()
{
  local image_name="${FUNCNAME[0]}"
  local git_repo_url=file://a/b/c

  build_start_points_image "${image_name}" "${git_repo_url}"

  assert_stdout_equals ''
  assert_stderr_equals "ERROR: <git-repo-url> ${git_repo_url} without preceding --custom/--exercises/--languages"
  assert_status_equals 7
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_custom_option_requires_at_least_one_following_git_repo_url()
{
  local image_name="${FUNCNAME[0]}"

  build_start_points_image "${image_name}" --custom

  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --custom requires at least one <git-repo-url>'
  assert_status_equals 8
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_exercises_option_requires_at_least_one_following_git_repo_url()
{
  local image_name="${FUNCNAME[0]}"

  build_start_points_image "${image_name}" --exercises

  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --exercises requires at least one <git-repo-url>'
  assert_status_equals 9
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_languages_option_requires_at_least_one_following_git_repo_url()
{
  local image_name="${FUNCNAME[0]}"

  build_start_points_image "${image_name}" --languages

  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --languages requires at least one <git-repo-url>'
  assert_status_equals 10
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_duplicate_custom_urls()
{
  local image_name="${FUNCNAME[0]}"
  local url='https://github.com/cyber-dojo/start-points-custom.git'

  build_start_points_image "${image_name}" --custom "${url}" "${url}"

  assert_stdout_equals ''
  assert_stderr_includes 'ERROR: --custom duplicated git-repo-urls'
  assert_stderr_includes "${url}"
  assert_stderr_line_count_equals 2
  assert_status_equals 11
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_duplicate_exercise_urls()
{
  local image_name="${FUNCNAME[0]}"
  local url='https://github.com/cyber-dojo/start-points-exercises.git'

  build_start_points_image "${image_name}" --exercises "${url}" "${url}"

  assert_stdout_equals ''
  assert_stderr_includes 'ERROR: --exercises duplicated git-repo-urls'
  assert_stderr_includes "${url}"
  assert_stderr_line_count_equals 2
  assert_status_equals 12
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_duplicate_language_urls()
{
  local image_name="${FUNCNAME[0]}"
  local url='https://github.com/cyber-dojo-languages/ruby-minitest'

  build_start_points_image "${image_name}" --languages "${url}" "${url}"

  assert_stdout_equals ''
  assert_stderr_includes 'ERROR: --languages duplicated git-repo-urls'
  assert_stderr_includes "${url}"
  assert_stderr_line_count_equals 2
  assert_status_equals 13
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_malformed_image_name()
{
  local image_name='ALPHA/name' # no upper-case

  build_start_points_image "${image_name}"

  assert_stderr_includes "ERROR: malformed <image-name> ${image_name}"
  assert_stderr_line_count_equals 1
  assert_status_equals 14
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
