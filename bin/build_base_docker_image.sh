#!/usr/bin/env bash
set -Eeu

build_base_docker_image()
{
  docker build \
    --build-arg SHA="$(git_commit_sha)" \
    --platform=linux/amd64 \
    --tag "$(image_name):latest" \
    "$(root_dir)"
}

