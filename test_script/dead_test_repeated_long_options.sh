#!/bin/bash

echo "::${0##*/}"

test_repeated_long_options()
{
  local image_name="${FUNCNAME[0]}"
  make_TMP_DIR_for_git_repos
  local E1_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises-bowling-game)
  local E2_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises-tiny-maze)

  build_start_points_image        \
    "${image_name}"               \
      --exercises "${E1_TMP_URL}" \
      --exercises "${E2_TMP_URL}"

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
