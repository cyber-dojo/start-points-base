#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly MY_IMAGE_NAME=cyberdojo/start-points-base-test

# build the FROM image so it won't be docker pulled
${MY_DIR}/build_docker_images.sh

# smoke test building an image
./${SCRIPT} \
  ${MY_IMAGE_NAME} \
    https://github.com/cyber-dojo/start-points-languages.git \
    https://github.com/cyber-dojo/start-points-exercises.git \
    https://github.com/cyber-dojo/start-points-custom.git    \

# docker login so we can...
echo "${DOCKER_PASSWORD}" \
  | docker login -u "${DOCKER_USERNAME}" --password-stdin

# save the image
docker push cyberdojo/start-points-base
