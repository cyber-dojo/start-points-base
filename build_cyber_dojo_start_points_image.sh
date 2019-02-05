#!/usr/bin/env bash
set -e
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Design choice: where to git-clone?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 1) directly, from this script, into the context dir
#    before running [docker image build].
#    This will run on the host.
# 2) indirectly, inside a command in the Dockerfile
#    passed to [docker image build].
#    This will run wherever the docker daemon is.
#
# I choose 1) since 2) will not work for some local
# file:///... urls on Docker-Toolbox.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

readonly IMAGE_NAME="${1}"

declare -a CUSTOM_URLS=()
declare -a EXERCISE_URLS=()
declare -a LANGUAGE_URLS=()

exit_zero_if_show_use()
{
  if docker container run --rm $(base_image_name) \
      ruby /app/src/from_script/show_use.rb "${0}" "${1}"; then
    exit 0
  fi
}

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

error()
{
  >&2 echo "ERROR: ${2}"
  exit "${1}"
}

gather_urls_from_args()
{
  local urls="${*}" # already checked
  local type=''
  for url in ${urls}; do
    if [ "${url}" = '--custom'    ] || \
       [ "${url}" = '--exercises' ] || \
       [ "${url}" = '--languages' ]
    then
      type="${url}"
    else
      case "${type}" in
      '--custom'   )   CUSTOM_URLS+=("${url}");;
      '--exercises') EXERCISE_URLS+=("${url}");;
      '--languages') LANGUAGE_URLS+=("${url}");;
      esac
    fi
  done
}

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
      https://github.com/cyber-dojo-languages/csharp-nunit         \
      https://github.com/cyber-dojo-languages/gcc-googletest       \
      https://github.com/cyber-dojo-languages/gplusplus-googlemock \
      https://github.com/cyber-dojo-languages/java-junit           \
      https://github.com/cyber-dojo-languages/javascript-jasmine   \
      https://github.com/cyber-dojo-languages/python-pytest        \
      https://github.com/cyber-dojo-languages/ruby-minitest        \
    )
  fi
}

prepare_context_dir()
{
  CONTEXT_DIR=$(mktemp -d)
  trap remove_context_dir EXIT
  mkdir "${CONTEXT_DIR}/custom"
  mkdir "${CONTEXT_DIR}/exercises"
  mkdir "${CONTEXT_DIR}/languages"
}

remove_context_dir()
{
  rm -rf "${CONTEXT_DIR}" > /dev/null
}

git_clone_all_urls_into_context_dir()
{
  for url in "${CUSTOM_URLS[@]}"; do
    git_clone_one_url_to_context_dir "${url}" custom
  done
  for url in "${EXERCISE_URLS[@]}"; do
    git_clone_one_url_to_context_dir "${url}" exercises
  done
  for url in "${LANGUAGE_URLS[@]}"; do
    git_clone_one_url_to_context_dir "${url}" languages
  done
}

declare URL_INDEX=0

git_clone_one_url_to_context_dir()
{
  local url="${1}"
  local type="${2}"
  cd "${CONTEXT_DIR}/${type}"
  local stderr
  if ! stderr="$(git clone --depth 1 "${url}" "${URL_INDEX}" 2>&1)"; then
    local newline=$'\n'
    local msg="git clone bad <git-repo-url>${newline}"
    msg+="--${type} ${url}${newline}"
    msg+="${stderr}"
    error 15 "${msg}"
  fi

  local sha
  sha=$(cd ${URL_INDEX} && git rev-parse HEAD)
  echo -e "--${type} \t ${url}"
  echo -e "${URL_INDEX} \t ${sha} \t ${url}" >> "${CONTEXT_DIR}/${type}_shas.txt"
  rm -rf "${CONTEXT_DIR}/${type}/${URL_INDEX}/.git"
  # Two or more git-repo-urls could have the same name
  # but be from different repositories.
  # So git clone each repo into its own unique directory
  # based on a simple incrementing index.
  URL_INDEX=$((URL_INDEX + 1))
}

build_image_from_context_dir()
{
  echo "FROM $(base_image_name)" > "${CONTEXT_DIR}/Dockerfile"
  local stderr
  if ! stderr=$(docker image build \
        --quiet                    \
        --tag "${IMAGE_NAME}"      \
        "${CONTEXT_DIR}" 2>&1)
  then
    # We are building FROM an image that has an ONBUILD.
    # We want the output from that ONBUILD.
    # But we don't want the output from [docker build] itself.
    # Hence the --quiet option. stderr looks like this
    #   1 Sending build context to Docker daemon  185.9kB
    #   2 Step 1/1 : FROM cyberdojo/start-points-base:latest
    #   3 # Executing 2 build triggers
    #   4  ---> Running in fe6adeee193c
    #   5 ERROR: no manifest.json files in
    #   6 --custom file:///Users/.../custom_no_manifests
    #   7 The command '/bin/sh -c ruby ...' returned a non-zero code: 16
    #
    # We want only lines 5,6
    echo "${stderr}" \
      | grep --invert-match 'Sending build context to Docker'  \
      | grep --invert-match 'Step 1/1 : FROM cyberdojo'        \
      | grep --invert-match '# Executing 2 build triggers'     \
      | grep --invert-match ' ---> Running in'                 \
      | >&2 grep --invert-match "The command '/bin/sh -c ruby" \
      || :
    # TODO: get status from last line and exit that...
    exit 16
  else
    : #TODO: echo "Successfully tagged ${IMAGE_NAME}"
  fi
}

base_image_name()
{
  # Must be pushed to dockerhub in .circleci/config.yml
  echo 'cyberdojo/start-points-base:latest'
}

# - - - - - - - - - - - - - - - - -

exit_zero_if_show_use "${*}"
exit_non_zero_if_bad_args "${*}"
exit_non_zero_unless_git_installed
exit_non_zero_unless_docker_installed

shift # image_name
gather_urls_from_args "${*}"
set_default_urls
prepare_context_dir
git_clone_all_urls_into_context_dir
build_image_from_context_dir
