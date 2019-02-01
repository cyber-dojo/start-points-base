
declare git_repo_tmp_dir=''

oneTimeTearDown()
{
  if [ -n "${git_repo_tmp_dir}" ]; then
    echo "inside OnTimeTearDown"
    whoami
    pwd
    ls -al "${git_repo_tmp_dir}"
    rm -rf "${git_repo_tmp_dir}"
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - -

script_dir()
{
  cd "$( dirname "${BASH_ARGV[0]}" )" && pwd
}

#- - - - - - - - - - - - - - - - - - - - - - -

root_dir()
{
  cd "$(script_dir)" && cd .. && pwd
}

#- - - - - - - - - - - - - - - - - - - - - - -

make_tmp_dir_for_git_repos()
{
  # Be careful to put this somewhere it can be seen
  # in the docker-context even if using Docker-Toolbox
  local tmp_dir=$(mktemp -d "$(root_dir)/tmp/cyber-dojo-start-points-base.XXX")
  git_repo_tmp_dir="${tmp_dir}"
  echo "${tmp_dir}"
}

#- - - - - - - - - - - - - - - - - - - - - - -

create_git_repo_from_named_data_set()
{
  local tmp_dir="${1}"
  local data_set_name="${2}"
  docker run \
    --user root \
    --rm \
    --volume "${tmp_dir}/${data_set_name}:/app/tmp/${data_set_name}:rw" \
    cyberdojo/create-start-points-test-data \
      "${data_set_name}" \
      "/app/tmp/${data_set_name}"
}

#- - - - - - - - - - - - - - - - - - - - - - -

build_start_points_image()
{
  local script_name="$(root_dir)/build_cyber_dojo_start_points_image.sh"
  ${script_name} ${*} >${stdoutF} 2>${stderrF}
  status=$?
  echo ${status} >${statusF}
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

#- - - - - - - - - - - - - - - - - - - - - - -

refute_image_created()
{
  local image_name="${1}"
  assertFalse "docker image ls | grep ${image_name}"
}

#- - - - - - - - - - - - - - - - - - - - - - -

assert_image_created()
{
  local image_name="${1}"
  assertTrue "docker image ls | grep ${image_name}"
}
