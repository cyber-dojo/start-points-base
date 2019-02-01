
oneTimeTearDown()
{
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
  # TODO: if using Docker-Toolbox
  # check $(root_dir) is under /Users
  cd "$(script_dir)" && cd .. && pwd
}

#- - - - - - - - - - - - - - - - - - - - - - -

TMP_DIR=''

make_TMP_DIR_for_git_repos()
{
  TMP_DIR=$(mktemp -d "$(root_dir)/tmp/cyber-dojo-start-points-base.XXX")
}

create_git_repo_in_TMP_DIR_from()
{
  local data_set_name="${1}"
  local user_id=$(id -u $(whoami))
  docker run \
    --rm \
    --volume "${TMP_DIR}/${data_set_name}:/app/tmp/:rw" \
    cyberdojo/create-start-points-test-data \
      "${data_set_name}" \
      "/app/tmp" \
      "${user_id}"
  echo "${TMP_DIR}/${data_set_name}"
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
