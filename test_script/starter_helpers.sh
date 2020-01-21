
declare -a TMP_DIRS=()
declare TMP_DIR=''

declare -a IMAGE_NAMES=()
declare IMAGE_NAME=''

#- - - - - - - - - - - - - - - - - - - - - - -
oneTimeTearDown()
{
  # This script is designed to be sourced from an shunit2 test.
  remove_TMP_DIRS
  remove_start_points_images
}

#- - - - - - - - - - - - - - - - - - - - - - -
remove_TMP_DIRS()
{
  for tmp_dir in "${TMP_DIRS[@]}"; do
    if [ -n "${tmp_dir}" ]; then
      rm -rf "${tmp_dir}"
    fi
  done
}

#- - - - - - - - - - - - - - - - - - - - - - -
remove_start_points_images()
{
  for image_name in "${IMAGE_NAMES[@]}"; do
    if [ -n "${image_name}" ]; then
      if image_exists "${image_name}"; then
        docker image rm "${image_name}" > /dev/null
      fi
    fi
  done
}

#- - - - - - - - - - - - - - - - - - - - - - -
my_dir()
{
  cd "$( dirname "${BASH_ARGV[0]}" )" && pwd
}

root_dir()
{
  cd "$(my_dir)" && cd .. && pwd
}

on_ci()
{
  [ -n "${CIRCLE_SHA1}" ]
}

#- - - - - - - - - - - - - - - - - - - - - - -
cyber_dojo()
{
  local -r name=cyber-dojo
  if [ -x "$(command -v ${name})" ]; then
    >&2 echo "Found executable ${name} on the PATH"
    echo "${name}"
  else
    local -r tmp_dir=$(mktemp -d "/tmp/cyber-dojo-start-points-base.XXX")
    TMP_DIRS+=("${tmp_dir}")
    local -r url="https://raw.githubusercontent.com/cyber-dojo/commander/master/${name}"
    >&2 echo "Did not find executable ${name} on the PATH"
    >&2 echo "Attempting to curl it from ${url}"
    curl --fail --output "${tmp_dir}/${name}" --silent "${url}"
    chmod 700 "${tmp_dir}/${name}"
    echo "${tmp_dir}/${name}"
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - -
exit_if_bad_ROOT_DIR()
{
  if using_DockerToolbox && on_Mac; then
    declare -r ROOT_DIR=$(root_dir)
    if [ "${ROOT_DIR:0:6}" != '/Users' ]; then
      >&2 echo 'ERROR'
      >&2 echo 'You are using Docker-Toolbox for Mac'
      >&2 echo "This script lives off ${ROOT_DIR}"
      >&2 echo 'It must live off /Users so the docker-context'
      >&2 echo "is automatically mounted into the default VM"
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
make_tmp_dir()
{
  local -r tmp_dir=$(mktemp -d "$(root_dir)/tmp/cyber-dojo-start-points-base.XXX")
  TMP_DIRS+=("${tmp_dir}")
  echo "${tmp_dir}"
}

git_repo_url_in_TMP_DIR_from()
{
  local -r data_set_name="${1}"
  local -r data_dir="$(make_tmp_dir)/${data_set_name}"
  local -r user_id=$(id -u $(whoami))

  docker run                                \
    --rm                                    \
    --volume "${data_dir}:/app/tmp/:rw"     \
    cyberdojo/create-start-points-test-data \
      "${data_set_name}"                    \
      "/app/tmp"                            \
      "${user_id}"

  echo "file://${data_dir}"
}

#- - - - - - - - - - - - - - - - - - - - - - -
build_start_points_image()
{
  IMAGE_NAME="${1}"
  IMAGE_NAMES+=("${IMAGE_NAME}")
  $(cyber_dojo) start-point create ${@} >${stdoutF} 2>${stderrF}
  status=$?
  echo ${status} >${statusF}
}

build_start_points_image_custom()
{
  local -r image_name="${1}"
  local -r url="${2}"
  build_start_points_image "${image_name}" --custom "${url}"
}

build_start_points_image_exercises()
{
  local -r image_name="${1}"
  local -r url="${2}"
  build_start_points_image "${image_name}" --exercises "${url}"
}

build_start_points_image_languages()
{
  local -r image_name="${1}"
  local -r url="${2}"
  build_start_points_image "${image_name}" --languages "${url}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
image_exists()
{
  local -r image_name=${1:-${IMAGE_NAME}}
  docker image inspect ${image_name} >/dev/null 2>&1
}

refute_image_created()
{
  local -r msg="refute_image_created ${IMAGE_NAME}"
  assertFalse "${msg}" image_exists
}

assert_image_created()
{
  local -r msg="assert_image_created ${IMAGE_NAME}"
  assertTrue "${msg}" image_exists
}

#- - - - - - - - - - - - - - - - - - - - - - -
assert_stdout_equals_use()
{
  local -r help_line_1="Use:"
  local -r help_line_2="cyber-dojo start-point create <name> --custom    <url> ..."
  local -r help_line_3="cyber-dojo start-point create <name> --exercises <url> ..."
  local -r help_line_4="cyber-dojo start-point create <name> --languages <url> ..."
  assert_stdout_includes "${help_line_1}"
  assert_stdout_includes "${help_line_2}"
  assert_stdout_includes "${help_line_3}"
  assert_stdout_includes "${help_line_4}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cd_github_org()
{
  echo https://github.com/cyber-dojo
}
