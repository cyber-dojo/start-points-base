#!/bin/bash

test_bad_git_url()
{
  local bad_url='abc:///wibble/ert/yui'
  local image_name="${FUNCNAME[0]}"
  build_start_points_image \
    "${image_name}"        \
      --custom             \
        "${bad_url}"

  refute_image_created
  assert_stderr_includes 'ERROR: git clone bad <git-repo-url>'
  assert_stderr_includes "--custom ${bad_url}"
  # "fatal: Unable to find remote helper for 'abc'"
  assert_status_equals 15
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
