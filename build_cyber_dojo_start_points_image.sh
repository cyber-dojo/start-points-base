#!/usr/bin/env bash
set -e

readonly MY_NAME=$(basename "$0")
readonly IMAGE_NAME="${1}"
readonly REPO_NAMES="${@:2}"

# - - - - - - - - - - - - - - - - -

show_use()
{
  echo "use: ${MY_NAME} <image-name> <git-repo-urls>"
  echo ""
  echo "Create a cyber-dojo start-point image."
  echo "Its base image will be cyberdojo/start-points-base"
  echo "and it will contain clones of all the specified git repos."
  echo "Examples"
  echo "\$ ${MY_NAME} acme/one-start-point file:///.../asm-assert"
  echo "\$ ${MY_NAME} acme/start-points https://github.com/cyber-dojo/start-points.git"
  #TODO: explain you must end up with one of each of the 3 kinds
  #TODO: or, provide defaults for each of the 3?
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
readonly CONTEXT_DIR=$(mktemp -d /tmp/cyber-dojo-start-points.XXXXXXXXX)
cleanup() { rm -rf "${CONTEXT_DIR}" > /dev/null; }
trap cleanup EXIT
declare index=0
for repo_name in $REPO_NAMES; do
    cd "${CONTEXT_DIR}"
    git clone --verbose --depth 1 "${repo_name}" ${index}
    cd ${index}
    declare sha
    sha=$(git rev-parse HEAD)
    echo "${index} ${sha} ${repo_name}" >> "${CONTEXT_DIR}/shas.txt"
    index=$((index + 1))
done

# create a Dockerfile in the temp docker context
readonly DOCKERFILE=${CONTEXT_DIR}/Dockerfile
echo 'FROM cyberdojo/start-points-base'       >> "${DOCKERFILE}"
echo 'ARG HOME=/app/repos'                    >> "${DOCKERFILE}"
echo 'COPY . ${HOME}'                         >> "${DOCKERFILE}"
echo 'RUN ruby /app/src/check_all.rb ${HOME}' >> "${DOCKERFILE}"

# remove the Dockerfile from docker image
readonly DOCKER_IGNORE=${CONTEXT_DIR}/.dockerignore
echo "Dockerfile"    >> "${DOCKER_IGNORE}"
echo ".dockerignore" >> "${DOCKER_IGNORE}"

# build the image
docker build --tag "${IMAGE_NAME}" "${CONTEXT_DIR}"
