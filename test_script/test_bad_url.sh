#!/usr/bin/env bash

readonly error_code=3

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_bad_git_url()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r bad_url='abc:///wibble/ert/yui'

  build_start_points_image \
    "${image_name}"        \
      --custom             \
        "${bad_url}"

  refute_image_created
  local -r expected=(
    'ERROR: bad git clone <url>'
    "--custom ${bad_url}"
    "Cloning into '0'..."
    "git: 'remote-abc' is not a git command. See 'git --help'."
    "fatal: remote helper 'abc' aborted session"
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals "${error_code}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
