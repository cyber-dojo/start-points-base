
oneTimeTearDown()
{
  # This script is designed to be sourced from an shunit2 test.
  remove_TMP_DIRS
  remove_start_points_images
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

declare -a TMP_DIRS=()
declare TMP_DIR=''

make_TMP_DIR_for_git_repos()
{
  TMP_DIR=$(mktemp -d "$(root_dir)/tmp/cyber-dojo-start-points-base.XXX")
  TMP_DIRS+=("${TMP_DIR}")
}

git_repo_url_in_TMP_DIR_from()
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

  echo "file://${data_dir}"
}

remove_TMP_DIRS()
{
  for tmp_dir in "${TMP_DIRS[@]}"; do
    if [ -n "${tmp_dir}" ]; then
      rm -rf "${tmp_dir}"
    fi
  done
}

#- - - - - - - - - - - - - - - - - - - - - - -

declare -a IMAGE_NAMES=()
declare IMAGE_NAME=''

build_start_points_image()
{
  IMAGE_NAME="${1}"
  IMAGE_NAMES+=("${IMAGE_NAME}")
  local script_name="$(root_dir)/build_cyber_dojo_start_points_image.sh"
  ${script_name} ${*} >${stdoutF} 2>${stderrF}
  status=$?
  echo ${status} >${statusF}
}

build_start_points_image_cel()
{
  local image_name="${1}"
  local C_TMP_URL=$(git_repo_url_in_TMP_DIR_from custom-tennis)
  local E_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises-bowling-game)
  local L_TMP_URL=$(git_repo_url_in_TMP_DIR_from languages-python-unittest)
  build_start_points_image \
    "${image_name}"        \
    --custom               \
      "${C_TMP_URL}"       \
    --exercises            \
      "${E_TMP_URL}"       \
    --languages            \
      "${L_TMP_URL}"       \
      "${@:2}"
}

build_start_points_image_custom()
{
  local image_name="${1}"
  local url="${2}"
  build_start_points_image_cel \
    "${image_name}" --custom "${url}"
}

build_start_points_image_exercises()
{
  local image_name="${1}"
  local url="${2}"
  build_start_points_image_cel \
    "${image_name}" --exercises "${url}"
}

build_start_points_image_languages()
{
  local image_name="${1}"
  local url="${2}"
  build_start_points_image_cel \
    "${image_name}" --languages "${url}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

image_exists()
{
  local image_name=${1:-${IMAGE_NAME}}
  docker image inspect ${image_name} >/dev/null 2>&1
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

assert_stdout_equals_use()
{
  local help_line_1="Use:"
  local help_line_2="$ ./build_cyber_dojo_start_points_image.sh \\"
  local help_line_3="    <image-name> \\"
  local help_line_4="      [--custom    <git-repo-url>...]... \\"
  local help_line_5="      [--exercises <git-repo-url>...]... \\"
  local help_line_6="      [--languages <git-repo-url>...]..."
  assert_stdout_includes "${help_line_1}"
  assert_stdout_includes "${help_line_2}"
  assert_stdout_includes "${help_line_3}"
  assert_stdout_includes "${help_line_4}"
  assert_stdout_includes "${help_line_5}"
  assert_stdout_includes "${help_line_6}"
  assert_stdout_line_count_equals 78
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_stdout_includes_default_custom_url()
{
  local default_custom='https://github.com/cyber-dojo/start-points-custom.git'
  assert_stdout_includes "$(echo -e "--custom \t ${default_custom}")"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_stdout_includes_default_exercises_url()
{
  local default_exercises='https://github.com/cyber-dojo/start-points-exercises.git'
  assert_stdout_includes "$(echo -e "--exercises \t ${default_exercises}")"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_stdout_includes_default_languages_urls()
{
  local default_languages=( \
    'https://github.com/cyber-dojo-languages/csharp-nunit' \
    'https://github.com/cyber-dojo-languages/gcc-googletest' \
    'https://github.com/cyber-dojo-languages/gplusplus-googlemock' \
    'https://github.com/cyber-dojo-languages/java-junit'\
    'https://github.com/cyber-dojo-languages/javascript-jasmine' \
    'https://github.com/cyber-dojo-languages/python-pytest' \
    'https://github.com/cyber-dojo-languages/ruby-minitest' \
  )
  for default_language in ${default_languages}; do
    assert_stdout_includes "$(echo -e "--languages \t ${default_language}")"
  done
}
