#!/bin/bash

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

. ${my_dir}/starter_helpers.sh

test_000_help_message()
{
  build_start_points_image
  assert_stdout_includes_use
  assert_stdout_line_count_equals 56
  assert_stderr_equals ''
  assert_status_equals 0

  build_start_points_image --help
  assert_stdout_includes_use
  assert_stdout_line_count_equals 56
  assert_stderr_equals ''
  assert_status_equals 0
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
