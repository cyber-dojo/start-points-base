#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly IMAGE_NAME=cyberdojo/start-points

# build the FROM image so it won't be docker pulled
docker build \
  --tag cyberdojo/start-points-base \
  "${ROOT_DIR}"

# smoke test building an image
"${ROOT_DIR}/${SCRIPT}" \
  ${IMAGE_NAME} \
    https://github.com/cyber-dojo/start-points-languages.git \
    https://github.com/cyber-dojo/start-points-exercises.git \
    https://github.com/cyber-dojo/start-points-custom.git    \
