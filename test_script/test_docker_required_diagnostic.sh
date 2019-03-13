#!/bin/bash

echo "::${0##*/}"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_docker_must_be_installed()
{
  local image_name="${FUNCNAME[0]}"

  export DOCKER_PROGRAM='docker_xxx'
  build_start_points_image "${image_name}"
  unset DOCKER_PROGRAM

  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: docker is not installed!'
  assert_status_equals 2
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
