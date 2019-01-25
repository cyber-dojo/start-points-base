#!/usr/bin/env bash
set -e

readonly MY_NAME=$(basename "$0")
readonly IMAGE_NAME="${1}"
readonly REPO_NAMES="${*:2}"

# - - - - - - - - - - - - - - - - -

show_use_brief()
{
  cat <<- EOF

  Use: ./${MY_NAME} <image-name> \\
    --languages <git-repo-urls> \\
    --exercises <git-repo-urls> \\
    --custom    <git-repo-urls> \\

EOF
}

# - - - - - - - - - - - - - - - - -

show_use()
{
  show_use_brief
  cat <<- EOF
  Creates a cyber-dojo start-point image named <image-name>.
  Its base image will be cyberdojo/start-points-base.
  It will contain checked git clones of all the specified repos.

  Example
  \$ ${MY_NAME} acme/a-start-point \\
    --languages file:///.../asm-assert \\
                file:///.../java-junit \\
    --exercises file:///.../katas      \\
    --custom    file:///.../yahtzee    \\

  Example
  \$ ${MY_NAME} acme/another-start-point \\
    --languages https://github.com/.../my-languages.git \\
    --exercises https://github.com/.../my-exercises.git \\
    --custom    https://github.com/.../my-custom.git    \\

  Example
  \$ ${MY_NAME} acme/yet-another \\
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
    show_use
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
  # TODO: Drop this once defaults are in place...
  if [ -z "${REPO_NAMES}" ]; then
    show_use_brief
    error 4 'missing <git-repo-urls>'
  fi
}

# - - - - - - - - - - - - - - - - -

declare use_language_defaults='true'
declare use_exercise_defaults='true'
declare use_custom_defaults='true'

git_clone_one_repo_to_context_dir()
{
  local type="${1}"
  local repo_name="${2}"
  local index="${3}"
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
}

# - - - - - - - - - - - - - - - - -

git_clone_all_repos_to_context_dir()
{
  echo "${IMAGE_NAME}"
  declare type=''
  declare index=0
  for repo_name in $REPO_NAMES; do
      echo "${repo_name}"
      case "${repo_name}" in
      --languages) type=languages; continue;;
      --exercises) type=exercises; continue;;
      --custom)    type=custom;    continue;;
      esac
      if [ -z "${type}" ]; then
        error 5 "repo ${repo_name} without preceeding --languages/--exercises/--custom"
      fi
      git_clone_one_repo_to_context_dir "${type}" "${repo_name}" "${index}"
      index=$((index + 1))
  done
}

# - - - - - - - - - - - - - - - - -

git_clone_default_repos_to_context_dir()
{
  if [ "${use_language_defaults}" = 'true' ]; then
    echo 'use_language_defaults=true'
  fi
  if [ "${use_exercise_defaults}" = 'true' ]; then
    echo 'use_exercise_defaults=true'
  fi
  if [ "${use_custom_defaults}" = 'true' ]; then
    echo 'use_custom_defaults=true'
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

check_arguments
git_clone_all_repos_to_context_dir
git_clone_default_repos_to_context_dir
write_Dockerfile_to_context_dir
build_the_image_from_context_dir
