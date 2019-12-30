#!/bin/bash -Eeu

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

# - - - - - - - - - - - - - - - - - - - - - - - -
build_fake_versioner()
{
  local env_vars="${1}"
  local -r sha="$(git_commit_sha)"
  local -r tag="${sha:0:7}"
  local -r fake_sha="CYBER_DOJO_START_POINTS_BASE_SHA=${sha}"
  local -r fake_tag="CYBER_DOJO_START_POINTS_BASE_TAG=${tag}"
  local -r fake=fake_versioner
  docker rm --force ${fake} > /dev/null 2>&1 | true
  docker run --detach --name ${fake} alpine:latest sh -c 'mkdir /app' > /dev/null
  echo "${env_vars}" >  /tmp/.env
  echo "${fake_sha}" >> /tmp/.env # replaces earlier entry when exported
  echo "${fake_tag}" >> /tmp/.env # replaces earlier entry when exported
  docker cp /tmp/.env ${fake}:/app/.env
  docker commit ${fake} cyberdojo/versioner:latest > /dev/null 2>&1
  docker rm --force ${fake} > /dev/null 2>&1
  # show it
  docker run --rm -it cyberdojo/versioner:latest sh -c 'cat /app/.env' | tail -n -2
  echo "${fake_sha}:"
  echo "${fake_tag}:"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${ROOT_DIR}" && git rev-parse HEAD)
}

# - - - - - - - - - - - - - - - - - - - - - - - -
source ${ROOT_DIR}/sh/cat_env_vars.sh
build_fake_versioner "$(cat_env_vars)"
