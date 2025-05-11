#!/usr/bin/env bash
set -Eeu

tag_and_push_base_docker_image()
{
  echo "docker tag $(image_name):latest $(image_name):$(image_tag)"
  docker tag "$(image_name):latest" "$(image_name):$(image_tag)"
  # The built image must be pushed to dockerhub because it is used the FROM image
  # in the created dynamically Dockerfile in a `cyber-dojo start-point create` command.
  docker push "$(image_name):$(image_tag)"
}

