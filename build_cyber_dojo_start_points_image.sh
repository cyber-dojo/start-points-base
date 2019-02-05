#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Design choice: where to git-clone?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 1) directly from this script into the context dir
#    before running [docker image build].
#    This will run on the host.
# 2) indirectly inside a command in the Dockerfile
#    passed to [docker image build].
#    This will run wherever the docker daemon is.
#
# I choose 1) since 2) will not work for some local
# file:///... urls on Docker-Toolbox.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
set -e

readonly MY_NAME=$(basename "$0")
readonly IMAGE_NAME="${1}"

readonly CONTEXT_DIR=$(mktemp -d)
cleanup() { rm -rf "${CONTEXT_DIR}" > /dev/null; }
trap cleanup EXIT
mkdir "${CONTEXT_DIR}/custom"
mkdir "${CONTEXT_DIR}/exercises"
mkdir "${CONTEXT_DIR}/languages"

declare -a CUSTOM_URLS=()
declare -a EXERCISE_URLS=()
declare -a LANGUAGE_URLS=()

# - - - - - - - - - - - - - - - - -

exit_zero_if_show_use()
{
  if [ "${IMAGE_NAME}" = '' ] || [ "${IMAGE_NAME}" = '--help' ]; then
    docker container run --rm $(base_image_name) \
      ruby /app/src/from_script/show_use.rb "${MY_NAME}"
    exit 0
  fi
}

# - - - - - - - - - - - - - - - - -

exit_non_zero_if_bad_args()
{
  set +e
  docker container run --rm $(base_image_name) \
    ruby /app/src/from_script/bad_args.rb ${*}
  local status=$?
  set -e
  if [ "${status}" != "0" ]; then
    exit "${status}"
  fi
}

# - - - - - - - - - - - - - - - - -

error()
{
  >&2 echo "ERROR: ${2}"
  exit "${1}"
}

# - - - - - - - - - - - - - - - - -

exit_non_zero_unless_git_installed()
{
  local git="${GIT_PROGRAM:-git}"
  if ! hash "${git}" 2> /dev/null; then
    error 1 'git is not installed!'
  fi
}

exit_non_zero_unless_docker_installed()
{
  local docker="${DOCKER_PROGRAM:-docker}"
  if ! hash "${docker}" 2> /dev/null; then
    error 2 'docker is not installed!'
  fi
}

# - - - - - - - - - - - - - - - - -

gather_urls_from_args()
{
  local urls="${*}"
  local type=''
  for url in ${urls}; do
    case "${url}" in
    --custom)    type=custom;    continue;;
    --exercises) type=exercises; continue;;
    --languages) type=languages; continue;;
    esac
    case "${type}" in
    custom   )   CUSTOM_URLS+=("${url}");;
    exercises) EXERCISE_URLS+=("${url}");;
    languages) LANGUAGE_URLS+=("${url}");;
    esac
  done
}

# - - - - - - - - - - - - - - - - -

set_default_urls()
{
  if [ ${#CUSTOM_URLS[@]} -eq 0 ]; then
    CUSTOM_URLS=( \
      https://github.com/cyber-dojo/start-points-custom.git \
    )
  fi
  if [ ${#EXERCISE_URLS[@]} -eq 0 ]; then
    EXERCISE_URLS=( \
      https://github.com/cyber-dojo/start-points-exercises.git \
    )
  fi
  if [ ${#LANGUAGE_URLS[@]} -eq 0 ]; then
    LANGUAGE_URLS=( \
      https://github.com/cyber-dojo-languages/csharp-nunit \
      https://github.com/cyber-dojo-languages/gcc-googletest \
      https://github.com/cyber-dojo-languages/gplusplus-googlemock \
      https://github.com/cyber-dojo-languages/java-junit \
      https://github.com/cyber-dojo-languages/javascript-jasmine \
      https://github.com/cyber-dojo-languages/python-pytest \
      https://github.com/cyber-dojo-languages/ruby-minitest \
    )
  fi
}

# - - - - - - - - - - - - - - - - -

git_clone_urls_into_context_dir()
{
  for url in "${CUSTOM_URLS[@]}"; do
    git_clone_url_to_context_dir custom "${url}"
  done
  for url in "${EXERCISE_URLS[@]}"; do
    git_clone_url_to_context_dir exercises "${url}"
  done
  for url in "${LANGUAGE_URLS[@]}"; do
    git_clone_url_to_context_dir languages "${url}"
  done
}

# - - - - - - - - - - - - - - - - -
# Two or more git-repo-urls could have the same name
# but be from different repositories.
# So git clone each repo into its own unique directory
# based on a simple incrementing index.
declare urls_index=0

git_clone_url_to_context_dir()
{
  local type="${1}"
  local url="${2}"
  cd "${CONTEXT_DIR}/${type}"
  git clone --quiet --depth 1 "${url}" "${urls_index}"
  local sha
  sha=$(cd ${urls_index} && git rev-parse HEAD)
  echo -e "--${type} \t ${url}"
  echo -e   "${type} \t ${url} \t ${sha} \t ${urls_index}" >> "${CONTEXT_DIR}/shas.txt"
  rm -rf "${CONTEXT_DIR}/${type}/${urls_index}/.git"
  urls_index=$((urls_index + 1))
}

# - - - - - - - - - - - - - - - - -

build_image_from_context_dir()
{
  # We are building FROM an image that has an ONBUILD.
  # We want the output from that ONBUILD.
  # But we don't want the output from [docker build] itself.
  # Hence the --quiet option. But a [docker build --quiet]
  # still prints the sha of the created image.
  # Hence the grep --invert-match to not print that.
  # But grep --invert-match changes the $? status.
  # Hence the || : because of [set -e].
  local stdin='-'
  echo "FROM $(base_image_name)"         \
    | docker image build                 \
        --file "${stdin}"                \
        --quiet                          \
        --tag "${IMAGE_NAME}"            \
        "${CONTEXT_DIR}"                 \
    | grep --invert-match 'sha256:' || :
}

base_image_name()
{
  # Must be pushed to dockerhub in .circleci/config.yml
  echo 'cyberdojo/start-points-base:latest'
}

# - - - - - - - - - - - - - - - - -

exit_zero_if_show_use
exit_non_zero_if_bad_args "${*}"
exit_non_zero_unless_git_installed
exit_non_zero_unless_docker_installed

shift
gather_urls_from_args "${*}"
set_default_urls
git_clone_urls_into_context_dir
build_image_from_context_dir
