#!/usr/bin/env bash
set -Eeu

tag_base_docker_image()
{
  echo "docker tag $(image_name):latest $(image_name):$(image_tag)"
  docker tag "$(image_name):latest" "$(image_name):$(image_tag)"
}

