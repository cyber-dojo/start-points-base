#!/bin/bash
set -e

readonly MY_NAME=`basename "$0"`
readonly IMAGE_NAME="${1}"
readonly REPO_NAMES="${@:2}"

# - - - - - - - - - - - - - - - - -

show_use()
{
  echo "use: ${MY_NAME} <image-name> <git-repo-urls>"
  echo ""
  echo "Create a cyber-dojo start-point image."
  echo "Its base image will be cyberdojo/start-points-base"
  echo "and it will contain clones of all the specific git repos."
}

# - - - - - - - - - - - - - - - - -

exit_fail()
{
  exit 1
}

# - - - - - - - - - - - - - - - - -

check_git_is_installed()
{
  if ! hash git 2> /dev/null; then
    echo 'git needs to be installed'
    exit_fail
  fi
}

# - - - - - - - - - - - - - - - - -

check_docker_is_installed()
{
  if ! hash docker 2> /dev/null; then
    echo 'docker needs to be installed'
    exit_fail
  fi
}

# - - - - - - - - - - - - - - - - -

check_args()
{
  if [ "${IMAGE_NAME}" = '--help' ];  then
    show_use
    exit_fail
  fi
  if [ "${IMAGE_NAME}" = '' ]; then
    show_use
    echo 'NO image_name'
    exit_fail
  fi
  if [ "${REPO_NAMES}" = '' ]; then
    show_use
    echo 'NO git-repo-urls'
    exit_fail
  fi
}

# - - - - - - - - - - - - - - - - -

check_git_is_installed
check_docker_is_installed
check_args

# git clone all repos into docker context
readonly CONTEXT_DIR=$(mktemp -d /tmp/cyber-dojo-start-points.XXXXXXXXX)
cleanup() { rm -rf ${CONTEXT_DIR} > /dev/null; }
trap cleanup EXIT
cd ${CONTEXT_DIR}
declare index=0
for repo_name in $REPO_NAMES; do
    git clone --verbose --depth 1 ${repo_name} ${index}
    declare sha=$(cd ${index} && git rev-parse HEAD)
    echo "${index} ${sha} ${repo_name}" >> ${CONTEXT_DIR}/shas.txt
    ((index++))
done

# create a Dockerfile in the docker context
readonly DOCKERFILE=${CONTEXT_DIR}/Dockerfile
echo 'FROM  cyberdojo/start-points-base'      >> ${DOCKERFILE}
echo 'ARG HOME=/app/repos'                    >> ${DOCKERFILE}
echo 'COPY . ${HOME}'                         >> ${DOCKERFILE}
echo 'RUN ruby /app/src/check_all.rb ${HOME}' >> ${DOCKERFILE}

# remove unwanted files from docker image
readonly DOCKER_IGNORE=${CONTEXT_DIR}/.dockerignore
echo "Dockerfile"    >> ${DOCKER_IGNORE}
echo ".dockerignore" >> ${DOCKER_IGNORE}

# build the image
docker build --tag ${IMAGE_NAME} ${CONTEXT_DIR}
