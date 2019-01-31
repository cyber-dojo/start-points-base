
readonly shell_dir="$( cd "$( dirname "${0}" )" && pwd )"
readonly BUILD_START_POINTS_IMAGE=${shell_dir}/../build_cyber_dojo_start_points_image.sh

build_start_points_image()
{
  ${BUILD_START_POINTS_IMAGE} ${*} >${stdoutF} 2>${stderrF}
  status=$?
  echo ${status} >${statusF}
}

assert_stdout_includes_use()
{
  local help_line_1="  Use:"
  local help_line_2="   $ ./build_cyber_dojo_start_points_image.sh \\"
  local help_line_3="     <image-name> \\"
  local help_line_4="       [--languages <git-repo-urls>] \\"
  local help_line_5="       [--exercises <git-repo-urls>] \\"
  local help_line_6="       [--custom    <git-repo-urls>]"
  assert_stdout_includes "${help_line_1}"
  assert_stdout_includes "${help_line_2}"
  assert_stdout_includes "${help_line_3}"
  assert_stdout_includes "${help_line_4}"
  assert_stdout_includes "${help_line_5}"
  assert_stdout_includes "${help_line_6}"
}

refute_image_created()
{
  local image_name="${1}"
  assertFalse "docker image ls | grep ${image_name}"
}

assert_image_created()
{
  local image_name="${1}"
  assertTrue "docker image ls | grep ${image_name}"
}
