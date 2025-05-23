
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

on_ci()
{
  [ -n "${CI:-}" ]
}

#- - - - - - - - - - - - - - - - - - - - - - -
cyber_dojo()
{
  local -r name=cyber-dojo
  if [ -x "$(command -v ${name})" ]; then
    echo "${name}"
  else
    echo "ERROR: cyber-dojo not on PATH"
    exit 42
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - -
make_tmp_dir()
{
  # Must be off root_dir so docker-context is mounted into default VM
  local -r tmp_dir=$(mktemp -d "$(root_dir)/tmp/XXXXXX")
  TMP_DIRS+=("${tmp_dir}")
  echo "${tmp_dir}"
}

git_repo_url_in_TMP_DIR_from()
{
  local -r data_set_name="${1}"
  local -r data_dir="$(make_tmp_dir)/${data_set_name}"
  local -r user_id=$(id -u $(whoami))

  # cyberdojo/create-start-points-test-data
  # is created by test_data/build_docker_image.sh
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
  local -r help_line_2="cyber-dojo start-point create <name> --custom    <url>..."
  local -r help_line_3="cyber-dojo start-point create <name> --exercises <url>..."
  local -r help_line_4="cyber-dojo start-point create <name> --languages <url>..."
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
