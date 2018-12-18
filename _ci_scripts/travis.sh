#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly IMAGE_NAME=cyberdojo/start-points

# build the FROM image so it won't be docker pulled
docker build \
  --tag cyberdojo/start-points-base \
  ${MY_DIR}/..

# smoke test building an image
./${SCRIPT} \
  ${IMAGE_NAME} \
    https://github.com/cyber-dojo/start-points-languages.git \
    https://github.com/cyber-dojo/start-points-exercises.git \
    https://github.com/cyber-dojo/start-points-custom.git    \

# docker login so we can...
echo "${DOCKER_PASSWORD}" \
  | docker login -u "${DOCKER_USERNAME}" --password-stdin

# save the base image
docker push cyberdojo/start-points-base
# save the start-points image
docker push ${IMAGE_NAME}
