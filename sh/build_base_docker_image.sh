#!/bin/bash -Eeu

readonly ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
readonly BASE_SHA=$(cd "${ROOT_DIR}" && git rev-parse HEAD)

docker build \
  --build-arg BASE_SHA=${BASE_SHA} \
  --tag ${CYBER_DOJO_START_POINTS_BASE_IMAGE}:latest \
  "${ROOT_DIR}/app"
