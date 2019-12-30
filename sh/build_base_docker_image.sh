#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly BASE_SHA=$(cd "${ROOT_DIR}" && git rev-parse HEAD)
readonly TAG=${BASE_SHA:0:7}

docker build \
  --build-arg BASE_SHA=${BASE_SHA} \
  --tag cyberdojo/start-points-base:latest \
  "${ROOT_DIR}/app"

echo "${BASE_SHA}"
docker tag cyberdojo/start-points-base:latest cyberdojo/start-points-base:${TAG}
