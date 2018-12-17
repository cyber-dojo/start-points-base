#!/bin/bash
set -e

readonly MY_NAME=`basename "$0"`
readonly CONTEXT_DIR=$(mktemp -d /tmp/start-points.XXXXXXXXX)
readonly DOCKERFILE=${CONTEXT_DIR}/Dockerfile
readonly DOCKER_IGNORE=${CONTEXT_DIR}/.dockerignore
readonly IMAGE_NAME=${1}
readonly REPO_NAMES=${@:2}

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
    echo 'git is not installed'
    exit_fail
  fi
}

# - - - - - - - - - - - - - - - - -

check_docker_is_installed()
{
  if ! hash docker 2> /dev/null; then
    echo 'docker is not installed'
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
cd ${CONTEXT_DIR}
for (( index=1; index<=$REPO_NAMES; index++ )); do
    declare repo_name=${!index}
    git clone --verbose --depth 1 ${repo_name} ${index}
    declare sha=$(cd ${index} && git rev-parse HEAD)
    echo "${index} ${sha} ${repo_name}" >> ${CONTEXT_DIR}/shas.txt
done

# create a Dockerfile in the docker context
echo 'FROM  cyberdojo/start-points-base'      >> ${DOCKERFILE}
echo 'ARG HOME=/app/repos'                    >> ${DOCKERFILE}
echo 'COPY . ${HOME}'                         >> ${DOCKERFILE}
echo 'RUN ruby /app/src/check_all.rb ${HOME}' >> ${DOCKERFILE}

# remove unwanted files from docker image
echo "Dockerfile"    >> ${DOCKER_IGNORE}
echo ".dockerignore" >> ${DOCKER_IGNORE}

# build the image
docker build --tag ${IMAGE_NAME} ${CONTEXT_DIR}

# tidy up
rm -rf ${CONTEXT_DIR}

show_use
