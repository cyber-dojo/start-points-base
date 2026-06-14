#!/usr/bin/env bash
set -Eeu

tag_base_docker_image()
{
  # Tag the freshly built :latest image with the short-sha :TAG so the CI
  # 'docker image save' step (which saves :TAG) has an image to tar.
  # The push to dockerhub is done separately by the push-image job in
  # .github/workflows/main.yml (main branch only), which loads the image
  # from the cached tar. So no push is needed here.
  echo "docker tag $(image_name):latest $(image_name):$(image_tag)"
  docker tag "$(image_name):latest" "$(image_name):$(image_tag)"
}
