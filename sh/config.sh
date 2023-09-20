#!/usr/bin/env bash
set -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo "${CYBER_DOJO_START_POINTS_BASE_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  cd "$(root_dir)" && git rev-parse HEAD
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_tag()
{
  local -r sha="$(git_commit_sha)"
  echo "${sha:0:7}"
}
