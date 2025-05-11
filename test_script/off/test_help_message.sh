#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_no_arguments()
{
  build_start_points_image

  assert_stdout_equals_use
  assert_stderr_empty
  assert_status_0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_short_help_option()
{
  build_start_points_image -h

  assert_stdout_equals_use
  assert_stderr_empty
  assert_status_0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_long_help_option()
{
  build_start_points_image --help

  assert_stdout_equals_use
  assert_stderr_empty
  assert_status_0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
