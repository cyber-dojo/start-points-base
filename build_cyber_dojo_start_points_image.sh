#!/usr/bin/env bash
set -e

readonly MY_NAME=$(basename "$0")
readonly IMAGE_NAME="${1}"
if [ -n "${IMAGE_NAME}" ]; then
  shift
fi

# - - - - - - - - - - - - - - - - -

show_use()
{
  cat <<- EOF

  Use:
    \$ ./${MY_NAME} \\
      <image-name> \\
        [--languages <git-repo-urls>] \\
        [--exercises <git-repo-urls>] \\
        [--custom    <git-repo-urls>]

  Creates a cyber-dojo start-point image named <image-name>.
  Its base image will be cyberdojo/start-points-base.
  It will contain checked git clones of all the specified repo-urls.

  Example: local git-repo-urls

  \$ ${MY_NAME} \\
    acme/first-start-point \\
      --languages file:///.../java-junit \\
      --exercises file:///.../katas      \\
      --custom    file:///.../yahtzee

  Example: non-local git-repo-urls

  \$ ${MY_NAME} \\
    acme/second-start-point \\
      --languages https://github.com/.../my-languages.git \\
      --exercises https://github.com/.../my-exercises.git \\
      --custom    https://github.com/.../my-custom.git

  Example: multiple git-repo-urls for --languages

  \$ ${MY_NAME} \\
    acme/third-start-point \\
      --languages file:///.../asm-assert \\
                  file:///.../java-junit \\
      --exercises file:///.../katas      \\
      --custom    file:///.../yahtzee

  Example: use defaults for --languages and --exercises

  \$ ${MY_NAME} \\
    acme/fourth-start-point \\
      --custom    file:///.../yahtzee

  Example: git-repo-urls from a file

  \$ ${MY_NAME} \\
    acme/fifth-start-point \\
      --languages "\$(< my-language-selection.txt)"        \\
      --exercises https://github.com/.../my-exercises.git \\
      --custom    https://github.com/.../my-custom.git

  \$ cat my-language-selection.txt
  https://github.com/cyber-dojo-languages/java-junit
  https://github.com/cyber-dojo-languages/javascript-jasmine
  https://github.com/cyber-dojo-languages/python-pytest
  https://github.com/cyber-dojo-languages/ruby-minitest

EOF
}

# - - - - - - - - - - - - - - - - -

readonly CONTEXT_DIR=$(mktemp -d)
cleanup() { rm -rf "${CONTEXT_DIR}" > /dev/null; }
trap cleanup EXIT
mkdir "${CONTEXT_DIR}/languages"
mkdir "${CONTEXT_DIR}/exercises"
mkdir "${CONTEXT_DIR}/custom"

# - - - - - - - - - - - - - - - - -

error()
{
  >&2 echo "ERROR: ${2}"
  exit "${1}"
}

# - - - - - - - - - - - - - - - - -

exit_unless_git_installed()
{
  local git="${GIT_PROGRAM:-git}"
  if ! hash "${git}" 2> /dev/null; then
    error 1 'git is not installed!'
  fi
}

exit_unless_docker_installed()
{
  local docker="${DOCKER_PROGRAM:-docker}"
  if ! hash "${docker}" 2> /dev/null; then
    error 2 'docker is not installed!'
  fi
}

exit_if_show_use()
{
  if [ "${IMAGE_NAME}" = '' ] || [ "${IMAGE_NAME}" = '--help' ]; then
    show_use
    exit 0
  fi
}

exit_if_no_image_name()
{
  case "${IMAGE_NAME}" in
    --languages) error 3 '--languages requires preceding <image_name>';;
    --exercises) error 4 '--exercises requires preceding <image_name>';;
    --custom)    error 5 '--custom requires preceding <image_name>';;
  esac
}

# - - - - - - - - - - - - - - - - -

# Two or more git-repo-urls could have the same name.
# So git clone each repo into its own unique directory
# based on a simple incrementing index.
declare index=0

declare use_language_defaults='true'
declare use_exercise_defaults='true'
declare use_custom_defaults='true'

git_clone_one_repo_to_context_dir()
{
  local type="${1}"
  local repo_url="${2}"
  cd "${CONTEXT_DIR}/${type}"
  git clone --quiet --depth 1 "${repo_url}" "${index}"
  case "${type}" in
  languages) use_language_defaults='false';;
  exercises) use_exercise_defaults='false';;
  custom)    use_custom_defaults='false'  ;;
  esac
  declare sha
  sha=$(cd ${index} && git rev-parse HEAD)
  echo "--${type} ${index} ${sha} ${repo_url}"
  echo "${type} ${index} ${sha} ${repo_url}" >> "${CONTEXT_DIR}/shas.txt"
  rm -rf "${CONTEXT_DIR}/${type}/${index}/.git"
  index=$((index + 1))
}

# - - - - - - - - - - - - - - - - -

git_clone_all_repos_to_context_dir()
{
  declare git_repo_urls="${*}"
  declare type=''
  for git_repo_url in ${git_repo_urls}; do
    case "${git_repo_url}" in
    --languages) type=languages; continue;;
    --exercises) type=exercises; continue;;
    --custom)    type=custom;    continue;;
    esac
    if [ -z "${type}" ]; then
      error 6 "git-repo-url ${git_repo_url} without preceding --languages/--exercises/--custom"
    fi
    git_clone_one_repo_to_context_dir "${type}" "${git_repo_url}"
  done

  if [ "${git_repo_url}" = '--languages' ] &&
     [ "${use_language_defaults}" = 'true' ]
  then
    error 7 '--languages requires at least one <git-repo-url>'
  fi
  if [ "${git_repo_url}" = '--exercises' ] &&
     [ "${use_exercise_defaults}" = 'true' ]
  then
    error 8 '--exercises requires at least one <git-repo-url>'
  fi
  if [ "${git_repo_url}" = '--custom' ] &&
     [ "${use_custom_defaults}" = 'true' ]
  then
    error 9 '--custom requires at least one <git-repo-url>'
  fi
}

# - - - - - - - - - - - - - - - - -

git_clone_default_repos_to_context_dir()
{
  if [ "${use_language_defaults}" = 'true' ]; then
    echo 'using default <git-repo-urls> for --languages'
    git_clone_all_repos_to_context_dir --languages \
      https://github.com/cyber-dojo-languages/csharp-nunit         \
      https://github.com/cyber-dojo-languages/gcc-googletest       \
      https://github.com/cyber-dojo-languages/gplusplus-googlemock \
      https://github.com/cyber-dojo-languages/java-junit           \
      https://github.com/cyber-dojo-languages/javascript-jasmine   \
      https://github.com/cyber-dojo-languages/python-pytest        \
      https://github.com/cyber-dojo-languages/ruby-minitest
  fi
  if [ "${use_exercise_defaults}" = 'true' ]; then
    echo 'using default <git-repo-url> for --exercises'
    git_clone_all_repos_to_context_dir --exercises \
      https://github.com/cyber-dojo/start-points-exercises.git
  fi
  if [ "${use_custom_defaults}" = 'true' ]; then
    echo 'using default <git-repo-url> for --custom'
    git_clone_all_repos_to_context_dir --custom \
      https://github.com/cyber-dojo/start-points-custom.git
  fi
}

# - - - - - - - - - - - - - - - - -

build_the_image_from_context_dir()
{
  local from_stdin='-'
  echo 'FROM cyberdojo/start-points-base' \
    | docker build                        \
        --file "${from_stdin}"            \
        --tag "${IMAGE_NAME}"             \
        "${CONTEXT_DIR}"
}

# - - - - - - - - - - - - - - - - -

exit_unless_git_installed
exit_unless_docker_installed
exit_if_show_use
exit_if_no_image_name

git_clone_all_repos_to_context_dir "${*}"
git_clone_default_repos_to_context_dir
build_the_image_from_context_dir
