#!/usr/bin/env bash
set -e

readonly MY_NAME=$(basename "$0")
readonly IMAGE_NAME="${1}"
if [ ! -z "${IMAGE_NAME}" ]; then
  shift
fi

# - - - - - - - - - - - - - - - - -

show_use_small()
{
  cat <<- EOF

  Use:
    \$ ./${MY_NAME} \\
      <image-name> \\
        [--languages <git-repo-urls>] \\
        [--exercises <git-repo-urls>] \\
        [--custom    <git-repo-urls>]

EOF
}

# - - - - - - - - - - - - - - - - -

show_use_large()
{
  show_use_small
  cat <<- EOF
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

readonly tmp_dir=/tmp/cyber-dojo-start-points-base.XXXXXXXXX
readonly CONTEXT_DIR=$(mktemp -d ${tmp_dir})
cleanup() { rm -rf "${CONTEXT_DIR}" > /dev/null; }
trap cleanup EXIT
mkdir "${CONTEXT_DIR}/languages"
mkdir "${CONTEXT_DIR}/exercises"
mkdir "${CONTEXT_DIR}/custom"

# - - - - - - - - - - - - - - - - -

error()
{
  echo "ERROR: ${2}"
  exit "${1}"
}

# - - - - - - - - - - - - - - - - -

check_git_installed()
{
  if ! hash git 2> /dev/null; then
    error 1 'git needs to be installed'
  fi
}

check_docker_installed()
{
  if ! hash docker 2> /dev/null; then
    error 2 'docker needs to be installed'
  fi
}

check_image_name()
{
  case "${IMAGE_NAME}" in
    '')          show_use_large; exit 0;;
    --help)      show_use_large; exit 0;;
    --languages) show_use_small; error 3 'missing <image_name>';;
    --exercises) show_use_small; error 3 'missing <image_name>';;
    --custom)    show_use_small; error 3 'missing <image_name>';;
  esac
}

# - - - - - - - - - - - - - - - - -

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
  echo "${type} ${index} ${sha} ${repo_url}" >> "${CONTEXT_DIR}/shas.txt"
  rm -rf "${CONTEXT_DIR}/${type}/${index}/.git"
  index=$((index + 1))
}

# - - - - - - - - - - - - - - - - -

git_clone_all_repos_to_context_dir()
{
  declare repo_names="${*}"
  declare type=''
  for repo_name in ${repo_names}; do
    case "${repo_name}" in
    --languages) type=languages; continue;;
    --exercises) type=exercises; continue;;
    --custom)    type=custom;    continue;;
    esac
    echo "${repo_name}"
    if [ -z "${type}" ]; then
      error 4 "repo ${repo_name} without preceeding --languages/--exercises/--custom"
    fi
    git_clone_one_repo_to_context_dir "${type}" "${repo_name}"
  done

  if [ "${repo_name}" = '--languages' ] &&
     [ "${use_language_defaults}" = 'true' ]
  then
    error 5 '--languages requires a following <git-repo-url>'
  fi
  if [ "${repo_name}" = '--exercises' ] &&
     [ "${use_exercise_defaults}" = 'true' ]
  then
    error 6 '--exercises requires a following <git-repo-url>'
  fi
  if [ "${repo_name}" = '--custom' ] &&
     [ "${use_custom_defaults}" = 'true' ]
  then
    error 7 '--custom requires a following <git-repo-url>'
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

write_Dockerfile_to_context_dir()
{
  { echo 'FROM cyberdojo/start-points-base';
    echo 'COPY . /app/repos';
    echo 'RUN ruby /app/src/check_all.rb /app/repos';
  } >> "${CONTEXT_DIR}/Dockerfile"

  { echo "Dockerfile";
    echo ".dockerignore";
  } >> "${CONTEXT_DIR}/.dockerignore"
}

# - - - - - - - - - - - - - - - - -

build_the_image_from_context_dir()
{
  docker build --tag "${IMAGE_NAME}" "${CONTEXT_DIR}"
}

# - - - - - - - - - - - - - - - - -

check_git_installed
check_docker_installed
check_image_name

git_clone_all_repos_to_context_dir ${*}
git_clone_default_repos_to_context_dir
write_Dockerfile_to_context_dir
build_the_image_from_context_dir
