
readonly shell_dir="$( cd "$( dirname "${0}" )" && pwd )"
readonly BUILD_IMAGE_SCRIPT=${shell_dir}/../build_cyber_dojo_start_points_image.sh

build_image()
{
  ${BUILD_IMAGE_SCRIPT} ${*} >${stdoutF} 2>${stderrF}
  status=$?
  echo ${status} >${statusF}
}
