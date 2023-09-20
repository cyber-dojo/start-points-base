#!/usr/bin/env bash
set -Eeu

tag_base_docker_image()
{
  docker tag "$(image_name):latest" "$(image_name):$(image_tag)"
  if on_ci; then
    echo "${DOCKER_PASS}" | docker login --username "${DOCKER_USER}" --password-stdin
  fi
  docker push "$(image_name):$(image_tag)"
  if on_ci; then
    docker logout
  fi
}

