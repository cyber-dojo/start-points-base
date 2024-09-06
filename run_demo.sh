#!/usr/bin/env bash
set -Eeu

root_dir() { git rev-parse --show-toplevel; }
sh_dir() { echo "$(root_dir)/sh"; }

. "$(sh_dir)/build_base_docker_image.sh"
. "$(sh_dir)/build_docker_images.sh"

run_demo()
{
  docker compose \
    --file "$(root_dir)/docker-compose.yml" \
    up \
    --detach  \
    --force-recreate

  sleep 1
  open "http://localhost:4528"
}

build_base_docker_image
build_docker_images
run_demo
