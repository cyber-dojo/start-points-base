#!/usr/bin/env bash
set -e

show_use()
{
  readonly MY_NAME=$(basename "$0")
  cat <<- EOF

  Use: ./${MY_NAME} <image-name> \\
    --languages <git-repo-urls> \\
    --exercises <git-repo-urls> \\
    --custom    <git-repo-urls> \\

  Creates a cyber-dojo start-point image named <image-name>.
  Its base image will be cyberdojo/start-points-base.
  It will contain git clones of all the specified repos.

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

error()
{
  echo "ERROR: ${2}"
  exit "${1}"
}

# - - - - - - - - - - - - - - - - -

readonly IMAGE_NAME="${1}"
readonly REPO_NAMES="${*:2}"

if [ -z "${IMAGE_NAME}" ] || [ "${IMAGE_NAME}" = '--help' ];  then
  show_use
  exit 0
fi
if ! hash git 2> /dev/null; then
  error 1 'git needs to be installed'
fi
if ! hash docker 2> /dev/null; then
  error 2 'docker needs to be installed'
fi
if [ -z "${IMAGE_NAME}" ]; then
  show_use
  error 3 'missing <image_name>'
fi
if [ -z "${REPO_NAMES}" ]; then
  show_use
  error 4 'missing <git-repo-urls>'
fi

# - - - - - - - - - - - - - - - - -

# git clone all repos into temp docker context
readonly CONTEXT_DIR=$(mktemp -d /tmp/cyber-dojo-start-points-base.XXXXXXXXX)
cleanup() { rm -rf "${CONTEXT_DIR}" > /dev/null; }
trap cleanup EXIT
mkdir "${CONTEXT_DIR}/languages"
mkdir "${CONTEXT_DIR}/exercises"
mkdir "${CONTEXT_DIR}/custom"

declare type=""
declare index=0
for repo_name in $REPO_NAMES; do
    case "${repo_name}" in
    --languages)
      type=languages
      continue
      ;;
    --exercises)
      type=exercises
      continue
      ;;
    --custom)
      type=custom
      continue
      ;;
    esac
    if [ -z "${type}" ]; then
      error 5 'missing --languages/--exercises/--custom'
    fi
    cd "${CONTEXT_DIR}/${type}"
    git clone --verbose --depth 1 "${repo_name}" ${index}
    cd ${index}
    declare sha
    sha=$(git rev-parse HEAD)
    echo "${type} ${index} ${sha} ${repo_name}" >> "${CONTEXT_DIR}/shas.txt"
    index=$((index + 1))
done

# create a Dockerfile in the temp docker context
{ echo 'FROM cyberdojo/start-points-base';
  echo 'COPY . /app/repos';
  echo 'RUN ruby /app/src/check_all.rb /app/repos';
} >> "${CONTEXT_DIR}/Dockerfile"

# remove the Dockerfile from docker image
{ echo "Dockerfile";
  echo ".dockerignore";
} >> "${CONTEXT_DIR}/.dockerignore"

# Attempt to build the image
docker build --tag "${IMAGE_NAME}" "${CONTEXT_DIR}"
