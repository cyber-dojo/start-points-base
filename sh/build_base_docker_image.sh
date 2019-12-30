#!/bin/bash -Eeu

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly BASE_SHA=$(cd "${ROOT_DIR}" && git rev-parse HEAD)

docker build \
  --build-arg BASE_SHA=${BASE_SHA} \
  --tag cyberdojo/start-points-base:latest \
  "${ROOT_DIR}/app"
