#!/usr/bin/env bash
set -Eeu

tag_base_docker_image()
{
  # Tag the freshly built :latest image with the short-sha :TAG, the name
  # 'make test_image' builds its derived test images from. This is the local
  # build only: CI builds both platforms itself in .github/workflows/main.yml
  # and releases to dockerhub from there, so no push is needed here.
  echo "docker tag $(image_name):latest $(image_name):$(image_tag)"
  docker tag "$(image_name):latest" "$(image_name):$(image_tag)"
}
