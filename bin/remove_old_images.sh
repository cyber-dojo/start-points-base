#!/usr/bin/env bash
set -Eeu

# Keeps :latest, which the build and dependent repos read, and this commit's
# tag, which names the build just made. Every older tag goes, and an earlier
# build whose last tag was one of those goes with it, so local builds stop
# accumulating images.
remove_old_images()
{
  local -r name="$(image_name)"
  local -r tag="$(image_tag)"
  echo Removing old images
  # grep exits non-zero when the machine holds no start-points-base image, eg
  # one whose images have just been cleared, so an empty list must not end the
  # build.
  local tagged_name
  for tagged_name in $(docker image ls --format '{{.Repository}}:{{.Tag}}' | grep "^${name}:" || true)
  do
    if [ "${tagged_name}" != "${name}:latest" ] \
    && [ "${tagged_name}" != "${name}:${tag}" ]; then
      # Removing by name:tag untags, so this succeeds even while a container
      # references the image, leaving it dangling until that container goes.
      docker image rm --force "${tagged_name}" || echo "  skipped ${tagged_name} (in use)"
    fi
  done
}
