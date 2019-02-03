
oneTimeTearDown()
{
  # This script is designed to be sourced from an shunit2 test.
  remove_TMP_DIR
  remove_start_points_image
}

#- - - - - - - - - - - - - - - - - - - - - - -

script_dir()
{
  cd "$( dirname "${BASH_ARGV[0]}" )" && pwd
}

root_dir()
{
  cd "$(script_dir)" && cd .. && pwd
}

exit_if_bad_ROOT_DIR()
{
  if using_DockerToolbox && on_Mac; then
    local ROOT_DIR=$(root_dir)
    if [ "${ROOT_DIR:0:6}" != "/Users" ]; then
      echo 'ERROR'
      echo 'You are using Docker-Toolbox for Mac'
      echo "This script lives off ${ROOT_DIR}"
      echo 'It must live off /Users so the docker-context'
      echo "is automatically mounted into the default VM"
      exit 1
    fi
  fi
}

using_DockerToolbox()
{
  [ -n "${DOCKER_MACHINE_NAME}" ]
}

on_Mac()
{
  # https://stackoverflow.com/questions/394230
  [[ "$OSTYPE" == "darwin"* ]]
}

exit_if_bad_ROOT_DIR

#- - - - - - - - - - - - - - - - - - - - - - -

TMP_DIR=''

make_TMP_DIR_for_git_repos()
{
  TMP_DIR=$(mktemp -d "$(root_dir)/tmp/cyber-dojo-start-points-base.XXX")
}

create_git_repo_in_TMP_DIR_from()
{
  local data_set_name="${1}"
  local data_dir="${TMP_DIR}/${data_set_name}"
  local user_id=$(id -u $(whoami))

  docker run                                \
    --rm                                    \
    --volume "${data_dir}:/app/tmp/:rw"     \
    cyberdojo/create-start-points-test-data \
      "${data_set_name}"                    \
      "/app/tmp"                            \
      "${user_id}"

  echo "${data_dir}"
}

remove_TMP_DIR()
{
  if [ -n "${TMP_DIR}" ]; then
    rm -rf "${TMP_DIR}"
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - -

IMAGE_NAME=''

build_start_points_image()
{
  IMAGE_NAME="${1}"
  local script_name="$(root_dir)/build_cyber_dojo_start_points_image.sh"
  ${script_name} ${*} >${stdoutF} 2>${stderrF}
  status=$?
  echo ${status} >${statusF}
}

image_exists()
{
  docker image inspect ${IMAGE_NAME} >/dev/null 2>&1
}

refute_image_created()
{
  local msg="refute_image_created ${IMAGE_NAME}"
  assertFalse "${msg}" image_exists
}

assert_image_created()
{
  local msg="assert_image_created ${IMAGE_NAME}"
  assertTrue "${msg}" image_exists
}

remove_start_points_image()
{
  if image_exists; then
    docker image rm "${IMAGE_NAME}" > /dev/null
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - -

assert_stdout_equals_use()
{
  local help_line_1="  Use:"
  local help_line_2="   $ ./build_cyber_dojo_start_points_image.sh \\"
  local help_line_3="     <image-name> \\"
  local help_line_4="       [--custom    <git-repo-urls>] \\"
  local help_line_5="       [--exercises <git-repo-urls>] \\"
  local help_line_6="       [--languages <git-repo-urls>]"
  assert_stdout_includes "${help_line_1}"
  assert_stdout_includes "${help_line_2}"
  assert_stdout_includes "${help_line_3}"
  assert_stdout_includes "${help_line_4}"
  assert_stdout_includes "${help_line_5}"
  assert_stdout_includes "${help_line_6}"
  assert_stdout_line_count_equals 56
}
