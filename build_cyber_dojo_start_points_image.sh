#!/usr/bin/env bash
set -e

readonly MY_NAME=$(basename "$0")
readonly IMAGE_NAME="${1}"
if [ -n "${IMAGE_NAME}" ]; then
  shift
fi
readonly CONTEXT_DIR=$(mktemp -d)
cleanup() { rm -rf "${CONTEXT_DIR}" > /dev/null; }
trap cleanup EXIT
mkdir "${CONTEXT_DIR}/custom"
mkdir "${CONTEXT_DIR}/exercises"
mkdir "${CONTEXT_DIR}/languages"

# - - - - - - - - - - - - - - - - -

show_use()
{
  cat <<- EOF

  Use:
    \$ ./${MY_NAME} \\
      <image-name> \\
        [--custom    <git-repo-url>...] \\
        [--exercises <git-repo-url>...] \\
        [--languages <git-repo-url>...]

  Creates a cyber-dojo start-point image named <image-name>.
  Its base image will be cyberdojo/start-points-base.
  It will contain checked git clones of all the specified repo-urls.

  Example: local git-repo-urls

  \$ ${MY_NAME} \\
    acme/first-start-point \\
      --custom    file:///.../yahtzee    \\
      --exercises file:///.../katas      \\
      --languages file:///.../java-junit

  Example: non-local git-repo-urls

  \$ ${MY_NAME} \\
    acme/second-start-point \\
      --custom    https://github.com/.../my-custom.git    \\
      --exercises https://github.com/.../my-exercises.git \\
      --languages https://github.com/.../my-languages.git

  Example: multiple git-repo-urls for --languages

  \$ ${MY_NAME} \\
    acme/third-start-point \\
      --custom    file:///.../yahtzee    \\
      --exercises file:///.../katas      \\
      --languages file:///.../asm-assert \\
                  file:///.../java-junit

  Example: use defaults for --exercises and --languages

  \$ ${MY_NAME} \\
    acme/fourth-start-point \\
      --custom    file:///.../yahtzee

  Example: git-repo-urls from a file

  \$ ${MY_NAME} \\
    acme/fifth-start-point \\
      --custom    https://github.com/.../my-custom.git     \\
      --exercises https://github.com/.../my-exercises.git   \\
      --languages "\$(< my-language-selection.txt)"

  \$ cat my-language-selection.txt
  https://github.com/cyber-dojo-languages/java-junit
  https://github.com/cyber-dojo-languages/javascript-jasmine
  https://github.com/cyber-dojo-languages/python-pytest
  https://github.com/cyber-dojo-languages/ruby-minitest

EOF
}

# - - - - - - - - - - - - - - - - -

error()
{
  >&2 echo "ERROR: ${2}"
  exit "${1}"
}

# - - - - - - - - - - - - - - - - -

exit_non_zero_if_git_not_installed()
{
  local git="${GIT_PROGRAM:-git}"
  if ! hash "${git}" 2> /dev/null; then
    error 1 'git is not installed!'
  fi
}

exit_non_zero_if_docker_not_installed()
{
  local docker="${DOCKER_PROGRAM:-docker}"
  if ! hash "${docker}" 2> /dev/null; then
    error 2 'docker is not installed!'
  fi
}

exit_non_zero_if_show_use()
{
  if [ "${IMAGE_NAME}" = '' ] || [ "${IMAGE_NAME}" = '--help' ]; then
    show_use
    # Exit with a non-zero value. CI/CD relies on a zero status
    # meaning an image was built and it ready to push.
    exit 3
  fi
}

exit_non_zero_if_bad_image_name()
{
  case "${IMAGE_NAME}" in
    --custom)    error 4 '--custom requires preceding <image_name>';;
    --exercises) error 5 '--exercises requires preceding <image_name>';;
    --languages) error 6 '--languages requires preceding <image_name>';;
  esac
  #TODO: check if image_name is malformed
}

# - - - - - - - - - - - - - - - - -

declare -a CUSTOM_URLS=()
declare -a EXERCISE_URLS=()
declare -a LANGUAGE_URLS=()

no_custom_git_repo_urls()
{
  [ ${#CUSTOM_URLS[@]} -eq 0 ]
}

no_exercise_git_repo_urls()
{
  [ ${#EXERCISE_URLS[@]} -eq 0 ]
}

no_language_git_repo_urls()
{
  [ ${#LANGUAGE_URLS[@]} -eq 0 ]
}

# - - - - - - - - - - - - - - - - -

gather_git_repo_urls_from_args()
{
  local urls="${*}"
  local type=''
  for url in ${urls}; do
    case "${url}" in
    --custom)    type=custom;    continue;;
    --exercises) type=exercises; continue;;
    --languages) type=languages; continue;;
    esac
    if [ -z "${type}" ]; then
      error 7 "<git-repo-url> ${url} without preceding --custom/--exercises/--languages"
    else
      case "${type}" in
      custom   )   CUSTOM_URLS+=("${url}");;
      exercises) EXERCISE_URLS+=("${url}");;
      languages) LANGUAGE_URLS+=("${url}");;
      esac
    fi
  done

  if [ "${url}" = '--custom' ] && no_custom_git_repo_urls; then
    error 8 '--custom requires at least one <git-repo-url>'
  fi
  if [ "${url}" = '--exercises' ] && no_exercise_git_repo_urls; then
    error 9 '--exercises requires at least one <git-repo-url>'
  fi
  if [ "${url}" = '--languages' ] && no_language_git_repo_urls; then
    error 10 '--languages requires at least one <git-repo-url>'
  fi
}

# - - - - - - - - - - - - - - - - -

set_default_git_repo_urls()
{
  if no_custom_git_repo_urls; then
    CUSTOM_URLS=( \
      https://github.com/cyber-dojo/start-points-custom.git \
    )
  fi
  if no_exercise_git_repo_urls; then
    EXERCISE_URLS=( \
      https://github.com/cyber-dojo/start-points-exercises.git \
    )
  fi
  if no_language_git_repo_urls; then
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

exit_non_zero_if_duplicate_git_repo_urls()
{
  exit_non_zero_if_duplicate_git_repo_urls_for 11 custom    "${CUSTOM_URLS[@]}"
  exit_non_zero_if_duplicate_git_repo_urls_for 12 exercises "${EXERCISE_URLS[@]}"
  exit_non_zero_if_duplicate_git_repo_urls_for 13 languages "${LANGUAGE_URLS[@]}"
}

exit_non_zero_if_duplicate_git_repo_urls_for()
{
  local status="${1}"
  local type="${2}"
  shift; shift
  local urls=("${@}")
  local count=$(printf '%s\n' "${urls[@]}"|awk '!($0 in seen){seen[$0];c++} END {print c}')
  if (( count != ${#urls[@]} )); then
    # error 2 'docker is not installed!'
    local newline=$'\n'
    local msg="--${type} duplicated git-repo-urls${newline}"
    msg="${msg}$(printf '%s\n' "${urls[@]}"|awk '!($0 in seen){seen[$0];next} 1')"
    error "${status}" "${msg}"
  fi
}

# - - - - - - - - - - - - - - - - -

git_clone_repos_into_context_dir()
{
  for url in "${CUSTOM_URLS[@]}"; do
    git_clone_one_repo_to_context_dir custom "${url}"
  done
  for url in "${EXERCISE_URLS[@]}"; do
    git_clone_one_repo_to_context_dir exercises "${url}"
  done
  for url in "${LANGUAGE_URLS[@]}"; do
    git_clone_one_repo_to_context_dir languages "${url}"
  done
}

# - - - - - - - - - - - - - - - - -
# Two or more git-repo-urls could have the same name
# but be from different repositories.
# So git clone each repo into its own unique directory
# based on a simple incrementing index.
declare git_repo_index=0

git_clone_one_repo_to_context_dir()
{
  local type="${1}"
  local url="${2}"
  cd "${CONTEXT_DIR}/${type}"
  git clone --quiet --depth 1 "${url}" "${git_repo_index}"
  local sha
  sha=$(cd ${git_repo_index} && git rev-parse HEAD)
  echo -e "--${type} \t ${url}"
  echo -e   "${type} \t ${url} \t ${sha} \t ${git_repo_index}" >> "${CONTEXT_DIR}/shas.txt"
  rm -rf "${CONTEXT_DIR}/${type}/${git_repo_index}/.git"
  git_repo_index=$((git_repo_index + 1))
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
  local from_stdin='-'
  echo "$(FROM_base_image_name)"         \
    | docker image build                 \
        --file "${from_stdin}"           \
        --quiet                          \
        --tag "${IMAGE_NAME}"            \
        "${CONTEXT_DIR}"                 \
    | grep --invert-match 'sha256:' || :
}

FROM_base_image_name()
{
  # Must be pushed to dockerhub in .circleci/config.yml
  echo 'FROM cyberdojo/start-points-base:latest'
}

# - - - - - - - - - - - - - - - - -

exit_non_zero_if_git_not_installed
exit_non_zero_if_docker_not_installed
exit_non_zero_if_show_use
exit_non_zero_if_bad_image_name

gather_git_repo_urls_from_args "${*}"
set_default_git_repo_urls
exit_non_zero_if_duplicate_git_repo_urls
git_clone_repos_into_context_dir
build_image_from_context_dir
