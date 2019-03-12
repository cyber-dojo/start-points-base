#!/usr/bin/env bash
set -e

declare -r MY_NAME=$(basename "${0}")
declare -r IMAGE_NAME="${1}"
declare -r IMAGE_TYPE="${2}"
declare -a GIT_REPO_URLS="(${@:3})"

show_use()
{
  cat <<- EOF

  Use:
  \$ ./${MY_NAME} \\
      <image-name> \\
        --custom|--exercises|--languages \\
          [<git-repo-url>...]

  Creates a cyber-dojo start-point docker image named <image-name>.
  Its base image will be cyberdojo/start-points-base.
  It will contain git clones of all the specified <git-repo-url>s.

  Example 1: local <git-repo-url>s

  \$ ./${MY_NAME} \\
        acme/first-start-point \\
          --custom \\
            file:///.../yahtzee

  Example 2: non-local <git-repo-url>s

  \$ ./${MY_NAME} \\
        acme/second-start-point \\
          --exercises \\
            https://github.com/.../my-exercises.git

  Example 3: multiple <git-repo-url>s

  \$ ./${MY_NAME} \\
        acme/third-start-point \\
          --languages \\
            file:///.../asm-assert \\
            file:///.../java-junit

  Example 4: read <git-repo-url>s from a file

  \$ ./${MY_NAME} \\
        acme/sixth-start-point \\
          --languages \\
            "\$(< my-language-selection.txt)"

  \$ cat my-language-selection.txt
  https://github.com/.../java-junit.git
  https://github.com/.../javascript-jasmine.git
  https://github.com/.../python-pytest.git
  https://github.com/.../ruby-minitest.git

EOF
  show_default_urls
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit_zero_if_show_use()
{
  local -r v0="${BASH_ARGV[0]}"
  if [ "${v0}" = '' ] || [ "${v0}" = '--help' ]; then
    show_use
    exit 0
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit_non_zero_if_bad_args()
{
  local -r args="${@}"
  set +e
  docker container run --rm $(base_image_name) \
    /app/src/from_script/bad_args.rb ${args}
  local -r status=$?
  set -e
  if [ "${status}" != "0" ]; then
    exit "${status}"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit_non_zero_unless_git_installed()
{
  local -r git="${GIT_PROGRAM:-git}"
  if ! hash "${git}" 2> /dev/null; then
    error 1 'git is not installed!'
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit_non_zero_unless_docker_installed()
{
  local -r docker="${DOCKER_PROGRAM:-docker}"
  if ! hash "${docker}" 2> /dev/null; then
    error 2 'docker is not installed!'
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

error()
{
  >&2 echo "ERROR: ${2}"
  exit "${1}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r CD_REPO_ORG=https://github.com/cyber-dojo
declare -r CDL_REPO_ORG=https://github.com/cyber-dojo-languages

declare -ar DEFAULT_CUSTOM_URLS=( \
  "${CD_REPO_ORG}/start-points-custom.git" \
)

declare -ar DEFAULT_EXERCISE_URLS=( \
  "${CD_REPO_ORG}/start-points-exercises.git" \
)

declare -ar DEFAULT_LANGUAGE_URLS=( \
  "${CDL_REPO_ORG}/csharp-nunit.git"         \
  "${CDL_REPO_ORG}/gcc-googletest.git"       \
  "${CDL_REPO_ORG}/gplusplus-googlemock.git" \
  "${CDL_REPO_ORG}/java-junit.git"           \
  "${CDL_REPO_ORG}/javascript-jasmine.git"   \
  "${CDL_REPO_ORG}/python-pytest.git"        \
  "${CDL_REPO_ORG}/ruby-minitest.git"        \
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set_default_urls()
{
  if [ ${#GIT_REPO_URLS[@]} -eq 0 ]; then
    case "$(image_type)" in
    'custom'   ) GIT_REPO_URLS=( "${DEFAULT_CUSTOM_URLS[@]}" );;
    'exercises') GIT_REPO_URLS=( "${DEFAULT_EXERCISES_URLS[@]}" );;
    'languages') GIT_REPO_URLS=( "${DEFAULT_LANGUAGES_URLS[@]}" );;
    esac
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

show_default_urls()
{
  echo '  Default <git-repo-url>s are:'
  echo '    --custom'
  for url in "${DEFAULT_CUSTOM_URLS[@]}"; do
    echo "      ${url}"
  done
  echo '    --exercises'
  for url in "${DEFAULT_EXERCISE_URLS[@]}"; do
    echo "      ${url}"
  done
  echo '    --languages'
  for url in "${DEFAULT_LANGUAGE_URLS[@]}"; do
    echo "      ${url}"
  done
  echo
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare CONTEXT_DIR

prepare_context_dir()
{
  CONTEXT_DIR=$(mktemp -d)
  trap remove_context_dir EXIT
  mkdir "${CONTEXT_DIR}/$(image_type)"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

remove_context_dir()
{
  rm -rf "${CONTEXT_DIR}" > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

git_clone_urls_into_context_dir()
{
  for url in "${GIT_REPO_URLS[@]}"; do
    git_clone_one_url_into_context_dir "${url}"
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -i URL_INDEX=0

git_clone_one_url_into_context_dir()
{
  # git-clone directly, from this script, into the
  # context dir before running [docker image build].
  # Viz, run [git clone] on the host rather than wherever
  # the docker daemon is (via a command in the Dockerfile).
  local -r url="${1}"
  cd "${CONTEXT_DIR}/$(image_type)"
  local stderr
  if ! stderr="$(git clone --depth 1 "${url}" "${URL_INDEX}" 2>&1)"; then
    local -r newline=$'\n'
    local msg="BAD git clone <git-repo-url>${newline}"
    msg+="${IMAGE_TYPE} ${url}${newline}"
    msg+="${stderr}"
    error 15 "${msg}"
  fi

  chmod -R +rX "${URL_INDEX}"
  local sha
  sha=$(cd ${URL_INDEX} && git rev-parse HEAD)
  echo -e "${IMAGE_TYPE} \t ${url}"
  echo -e "${URL_INDEX} \t ${sha} \t ${url}" >> "${CONTEXT_DIR}/$(image_type)_shas.txt"
  rm -rf "${CONTEXT_DIR}/$(image_type)/${URL_INDEX}/.git"
  rm -rf "${CONTEXT_DIR}/$(image_type)/${URL_INDEX}/docker"
  # Two or more git-repo-urls could have the same repo name
  # but be from different repositories.
  # So git clone each repo into its own unique directory
  # based on a simple incrementing index.
  URL_INDEX=$((URL_INDEX + 1))
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

build_image_from_context_dir()
{
  if [ -z "${DONT_PULL_START_POINTS_BASE}" ]; then
    docker pull "$(base_image_name)" >/dev/null 2>&1
  fi
  {
    echo "FROM $(base_image_name)"
    echo "LABEL org.cyber-dojo.start-point=$(image_type)"
    echo "ENV SERVER_TYPE=$(image_type)"
  } > "${CONTEXT_DIR}/Dockerfile"
  local output
  if ! output=$(docker image build \
        --quiet                    \
        --tag "${IMAGE_NAME}"      \
        "${CONTEXT_DIR}" 2>&1)
  then
    # We are building FROM an image that has ONBUILD instructions.
    # We want the output from those ONBUILDs.
    # But we don't want the output from [docker build] itself.
    # Hence the --quiet option.
    #
    # On a Macbook using Docker-Toolbox stderr looks like this
    #   1 Sending build context to Docker daemon  185.9kB
    #   2 Step 1/2 : FROM cyberdojo/start-points-base:latest
    #   3 # Executing 2 build triggers
    #   4  ---> Running in fe6adeee193c
    #---5 ERROR: no manifest.json files in
    #---6 --custom file:///Users/.../custom_no_manifests
    #   7 The command '/bin/sh -c ...' returned a non-zero code: 16
    #
    # On CircleCI stderr looks similar except for
    #   2  Step 1/1 : COPY . /app/repos
    #   3  Step 1/1 : RUN /app/src/on_build/check_all.rb /app/repos
    #
    # We want only lines 5,6
    echo "${output}" \
      | grep --invert-match 'Sending build context to Docker'  \
      | grep --invert-match 'Step 1/1'                         \
      | grep --invert-match 'Step 1/2'                         \
      | grep --invert-match '# Executing 2 build triggers'     \
      | grep --invert-match ' ---> Running in'                 \
      | >&2 grep --invert-match "The command '/bin/sh -c"      \
      || :
    local -r last_line="${output##*$'\n'}"
    local -r last_word="${last_line##* }"
    exit "${last_word}" # eg 16
  else
    echo "Successfully built ${IMAGE_NAME}"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

base_image_name()
{
  # Must be pushed to dockerhub in .circleci/config.yml
  echo 'cyberdojo/start-points-base:latest'
}

image_type()
{
  echo "${IMAGE_TYPE:2}"    # '--languages' => 'languages'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit_zero_if_show_use
exit_non_zero_if_bad_args "${@}"
exit_non_zero_unless_git_installed
exit_non_zero_unless_docker_installed

prepare_context_dir
set_default_urls
git_clone_urls_into_context_dir
build_image_from_context_dir
