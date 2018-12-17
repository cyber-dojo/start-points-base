#!/bin/bash
set -e

readonly MY_NAME=`basename "$0"`
readonly CONTEXT_DIR=$(mktemp -d /tmp/start-points.XXXXXXXXX)
readonly DOCKERFILE=${CONTEXT_DIR}/Dockerfile
readonly DOCKER_IGNORE=${CONTEXT_DIR}/.dockerignore
readonly IMAGE_NAME=${1}
shift
readonly REPO_NAMES=$#

# - - - - - - - - - - - - - - - - -

show_use()
{
  echo "Use: ${MY_NAME} <image-name> [git-repo-url...]"
}

# - - - - - - - - - - - - - - - - -

exit_fail()
{
  >&2 echo "FAILED: $*"
  exit 1
}

# - - - - - - - - - - - - - - - - -

check_docker_is_installed()
{
  if ! hash docker 2> /dev/null; then
    exit_fail 'docker is not installed'
  fi
}

# - - - - - - - - - - - - - - - - -

check_git_is_installed()
{
  if ! hash git 2> /dev/null; then
    exit_fail 'git is not installed'
  fi
}

# - - - - - - - - - - - - - - - - -
# todo: if no args or --help show_use
# todo: check $1==image-name is provided
# todo: check at least 1 repo-name is provided
echo "IMAGE_NAME=:${IMAGE_NAME}:"
echo "REPO_NAMES=:${REPO_NAMES}:"


# git clone all repos into docker context
show_use
check_git_is_installed
check_docker_is_installed
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
