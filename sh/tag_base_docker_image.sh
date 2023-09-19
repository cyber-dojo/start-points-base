#!/usr/bin/env bash
set -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "$(root_dir)" && git rev-parse HEAD)
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo "${CYBER_DOJO_START_POINTS_BASE_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
tag_image()
{
  local -r image="$(image_name)"
  local -r sha="$(git_commit_sha)"
  local -r tag="${sha:0:7}"
  docker tag "${image}:latest" "${image}:${tag}"
  if on_ci; then
    echo "${DOCKER_PASS}" | docker login --username "${DOCKER_USER}" --password-stdin
  fi
  docker push "${image}:${tag}"
  if on_ci; then
    docker logout
  fi
  echo "${sha}"
  echo "${tag}"
}

