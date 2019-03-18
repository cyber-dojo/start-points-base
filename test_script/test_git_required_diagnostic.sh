#!/bin/bash

echo "::${0##*/}"

test_git_must_be_installed()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local L_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-csharp-nunit)

  export GIT_PROGRAM='git_xxx'
  build_start_points_image       \
    "${image_name}"              \
      --languages "${L_TMP_URL}"
  unset GIT_PROGRAM

  assert_stdout_equals ''
  assert_stderr_equals 'ERROR: git is not installed!'
  assert_status_equals 1
  refute_image_created "${image_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
