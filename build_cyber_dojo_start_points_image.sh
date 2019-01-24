#!/usr/bin/env bash
set -e

readonly MY_NAME=$(basename "$0")
readonly IMAGE_NAME="${1}"
readonly REPO_NAMES="${*:2}"

# - - - - - - - - - - - - - - - - -

show_use()
{
  cat <<- EOF

  Use: ./${MY_NAME} <image-name> \
    --languages <git-repo-urls> \
    --exercises <git-repo-urls> \
    --custom    <git-repo-urls>

  Create a cyber-dojo start-point image named <image-name>.
  Its base image will be cyberdojo/start-points-base
  and it will contain clones of all the specified git repos.

  Examples
  \$ ${MY_NAME} acme/one-start-point \
    --languages file:///.../asm-assert \
    --exercises file:///.../katas \
    --custom    file:///.../Yahtzee-refactoring

  \$ ${MY_NAME} acme/start-points    \
    --languages https://github.com/.../my-languages.git \
    --exercises https://github.com/.../my-exercises.git \
    --custom    https://github.com/.../my-custom.git \

EOF
}

# - - - - - - - - - - - - - - - - -

error()
{
  echo "ERROR: ${2}"
  exit "${1}"
}

# - - - - - - - - - - - - - - - - -

if [ "${IMAGE_NAME}" = '--help' ];  then
  show_use; exit 0
fi
if ! hash git 2> /dev/null; then
  error 1 'git needs to be installed'
fi
if ! hash docker 2> /dev/null; then
  error 2 'docker needs to be installed'
fi
if [ -z "${IMAGE_NAME}" ]; then
  show_use; error 3 'missing <image_name>'
fi
if [ -z "${REPO_NAMES}" ]; then
  show_use; error 4 'missing <git-repo-urls>'
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

# build the image
docker build --tag "${IMAGE_NAME}" "${CONTEXT_DIR}"
