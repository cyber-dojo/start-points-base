#!/bin/bash

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

. ${my_dir}/starter_helpers.sh

test_001a_languages_requires_image_name()
{
  build_start_points_image --languages
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --languages requires preceding <image_name>'
  assert_status_equals 3
}

test_001b_exercises_requires_image_name()
{
  build_start_points_image --exercises
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --exercises requires preceding <image_name>'
  assert_status_equals 4
}

test_001c_custom_requires_image_name()
{
  build_start_points_image --custom
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --custom requires preceding <image_name>'
  assert_status_equals 5
}

test_001d_git_repo_url_requires_preceeding_languages_or_exercises_or_custom()
{
  local image_name=cyberdojo/dummy
  local git_repo_url=file://a/b/c
  build_start_points_image ${image_name} ${git_repo_url}
  assert_stdout_equals ''
  assert_stderr_equals "ERROR: git-repo-url ${git_repo_url} without preceding --languages/--exercises/--custom"
  assert_status_equals 6
}

test_001e_languages_requires_at_least_one_following_git_repo_url()
{
  local image_name=cyberdojo/dummy
  build_start_points_image ${image_name} --languages
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --languages requires at least one <git-repo-url>'
  assert_status_equals 7
}

test_001f_exercises_requires_at_least_one_following_git_repo_url()
{
  local image_name=cyberdojo/dummy
  build_start_points_image ${image_name} --exercises
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --exercises requires at least one <git-repo-url>'
  assert_status_equals 8
}

test_001g_custom_requires_at_least_one_following_git_repo_url()
{
  local image_name=cyberdojo/dummy
  build_start_points_image ${image_name} --custom
  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: --custom requires at least one <git-repo-url>'
  assert_status_equals 9
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
