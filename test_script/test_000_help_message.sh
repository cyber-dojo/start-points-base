#!/bin/bash
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh

test_000_help_message()
{
  build_start_points_image
  assert_stdout_equals_use
  assert_stderr_equals ''
  assert_status_equals 3

  build_start_points_image --help
  assert_stdout_equals_use
  assert_stderr_equals ''
  assert_status_equals 3
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
