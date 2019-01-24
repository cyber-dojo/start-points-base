#!/bin/bash

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

. ${my_dir}/starter_helpers.sh

test_000_help_message()
{
  local help_line1="Use: ./build_cyber_dojo_start_points_image.sh <image-name> \\"
  local help_line2="--languages <git-repo-urls> \\"

  build_image
  assert_stdout_includes "${help_line1}"
  assert_stdout_includes "${help_line2}"
  assert_stdout_line_count_equals 34
  assert_stderr_equals ''
  assert_status_equals 0

  build_image --help
  assert_stdout_includes "${help_line1}"
  assert_stdout_includes "${help_line2}"
  assert_stdout_line_count_equals 34
  assert_stderr_equals ''
  assert_status_equals 0
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
