#!/usr/bin/env bash
set -e

readonly MY_NAME=$(basename "$0")
readonly IMAGE_NAME="${1}"

# - - - - - - - - - - - - - - - - -

show_use_brief()
{
  cat <<- EOF

  Use:
    \$ ./${MY_NAME} \\
      <image-name> \\
        --languages <git-repo-urls> \\
        --exercises <git-repo-urls> \\
        --custom    <git-repo-urls> \\

EOF
}

# - - - - - - - - - - - - - - - - -

show_use_full()
{
  show_use_brief
  cat <<- EOF
  Creates a cyber-dojo start-point image named <image-name>.
  Its base image will be cyberdojo/start-points-base.
  It will contain checked git clones of all the specified repos.

  Example: local git-repo-urls
  \$ ${MY_NAME} \\
    acme/first-start-point \\
      --languages file:///.../java-junit \\
      --exercises file:///.../katas      \\
      --custom    file:///.../yahtzee    \\

  Example: non-local git-repo-urls
  \$ ${MY_NAME} \\
    acme/second-start-point \\
      --languages https://github.com/.../my-languages.git \\
      --exercises https://github.com/.../my-exercises.git \\
      --custom    https://github.com/.../my-custom.git    \\

  Example: multiple git-repo-urls for --languages
  \$ ${MY_NAME} \\
    acme/third-start-point \\
      --languages file:///.../asm-assert \\
                  file:///.../java-junit \\
      --exercises file:///.../katas      \\
      --custom    file:///.../yahtzee    \\

  Example:  defaulted --languages and --exercises
  \$ ${MY_NAME} \\
    acme/fourth-start-point \\
      --custom    file:///.../yahtzee    \\

  Example: git-repo-urls from a file
  \$ ${MY_NAME} \\
    acme/fifth-start-point \\
      --languages "\$(< my-language-selection.txt)"        \\
      --exercises https://github.com/.../my-exercises.git \\
      --custom    https://github.com/.../my-custom.git    \\

  \$ cat my-language-selection.txt
  https://github.com/cyber-dojo-languages/java-junit
  https://github.com/cyber-dojo-languages/javascript-jasmine
  https://github.com/cyber-dojo-languages/python-pytest
  https://github.com/cyber-dojo-languages/ruby-minitest

EOF
}

# - - - - - - - - - - - - - - - - -

readonly CONTEXT_DIR=$(mktemp -d /tmp/cyber-dojo-start-points-base.XXXXXXXXX)
mkdir "${CONTEXT_DIR}/languages"
mkdir "${CONTEXT_DIR}/exercises"
mkdir "${CONTEXT_DIR}/custom"
cleanup() { rm -rf "${CONTEXT_DIR}" > /dev/null; }
trap cleanup EXIT

# - - - - - - - - - - - - - - - - -

error()
{
  echo "ERROR: ${2}"
  exit "${1}"
}

# - - - - - - - - - - - - - - - - -

missing_image_name()
{
  # check_arguments() has already checked for empty IMAGE_NAME
  case "${IMAGE_NAME}" in
    --languages) true;;
    --exercises) true;;
    --custom)    true;;
    *)           false;;
  esac
}

# - - - - - - - - - - - - - - - - -

check_arguments()
{
  if [ -z "${IMAGE_NAME}" ] || [ "${IMAGE_NAME}" = '--help' ]; then
    show_use_full
    exit 0
  fi
  if ! hash git 2> /dev/null; then
    error 1 'git needs to be installed'
  fi
  if ! hash docker 2> /dev/null; then
    error 2 'docker needs to be installed'
  fi
  if missing_image_name; then
    show_use_brief
    error 3 'missing <image_name>'
  fi
}

# - - - - - - - - - - - - - - - - -

declare index=0

declare use_language_defaults='true'
declare use_exercise_defaults='true'
declare use_custom_defaults='true'

git_clone_one_repo_to_context_dir()
{
  local type="${1}"
  local repo_name="${2}"
  cd "${CONTEXT_DIR}/${type}"
  git clone --quiet --depth 1 "${repo_name}" "${index}"
  case "${type}" in
  languages) use_language_defaults='false';;
  exercises) use_exercise_defaults='false';;
  custom)    use_custom_defaults='false'  ;;
  esac
  declare sha
  sha=$(cd ${index} && git rev-parse HEAD)
  echo "${type} ${index} ${sha} ${repo_name}" >> "${CONTEXT_DIR}/shas.txt"
  rm -rf "${CONTEXT_DIR}/${type}/${index}/.git"
  index=$((index + 1))
}

# - - - - - - - - - - - - - - - - -

git_clone_all_repos_to_context_dir()
{
  declare repo_names="${1}"
  declare type=''
  for repo_name in ${repo_names}; do
    echo "${repo_name}"
    case "${repo_name}" in
    --languages) type=languages; continue;;
    --exercises) type=exercises; continue;;
    --custom)    type=custom;    continue;;
    esac
    if [ -z "${type}" ]; then
      error 4 "repo ${repo_name} without preceeding --languages/--exercises/--custom"
    fi
    git_clone_one_repo_to_context_dir "${type}" "${repo_name}"
  done
  #TODO: check for --languages and no following git-repo-url
}

# - - - - - - - - - - - - - - - - -

git_clone_default_repos_to_context_dir()
{
  if [ "${use_language_defaults}" = 'true' ]; then
    echo 'using default for --languages'
    #TODO...
  fi
  if [ "${use_exercise_defaults}" = 'true' ]; then
    local exercises_url="https://github.com/cyber-dojo/start-points-exercises.git"
    echo 'using default for --exercises'
    echo "${exercises_url}"
    git_clone_one_repo_to_context_dir "exercises" "${exercises_url}"
  fi
  if [ "${use_custom_defaults}" = 'true' ]; then
    local custom_url="https://github.com/cyber-dojo/start-points-exercises.git"
    echo 'using default for --custom'
    echo ${custom_url}""
    git_clone_one_repo_to_context_dir "custom" "${custom_url}"
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

readonly REPO_NAMES="${*:2}"

check_arguments
git_clone_all_repos_to_context_dir "${REPO_NAMES}"
git_clone_default_repos_to_context_dir
write_Dockerfile_to_context_dir
build_the_image_from_context_dir
