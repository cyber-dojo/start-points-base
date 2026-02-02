#!/usr/bin/env bash
set -Eeu

build_docker_images()
{
  docker compose \
    --file "$(root_dir)/docker-compose.yml" \
    build
}

