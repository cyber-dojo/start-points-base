#!/usr/bin/env bash
set -Eeu

# readonly ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
# readonly BASE_SHA=$(cd "${ROOT_DIR}" && git rev-parse HEAD)

build_base_docker_image()
{
  local -r base_sha=$(cd "$(root_dir)" && git rev-parse HEAD)

  docker build \
    --build-arg BASE_SHA=${base_sha} \
    --tag "${CYBER_DOJO_START_POINTS_BASE_IMAGE}:latest" \
    "$(root_dir)/app"
}

