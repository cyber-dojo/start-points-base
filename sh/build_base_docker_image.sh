#!/usr/bin/env bash
set -Eeu

build_base_docker_image()
{
  docker build \
    --build-arg BASE_SHA="$(git_commit_sha)" \
    --tag "$(image_name):latest" \
    "$(root_dir)/app"
}

