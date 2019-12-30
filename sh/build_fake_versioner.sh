#!/bin/bash -Eeu

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

# IDEA: instead of tunnelling CYBER_DOJO_START_POINTS_BASE_TAG into
# cyber-dojo-inner why not create a fake cyberdojo/versioner:latest
# TODO: use and delete code in
#       - sh/build_test_derived_images.sh
#       - test_script/run_tests.sh
# TODO: Need an EXIT trap handler to remove cyberdojo/versioner:latest
# as it fake
# - - - - - - - - - - - - - - - - - - - - - - - -
build_fake_versioner()
{
  local env_vars="${1}"
  local -r sha="$(git_commit_sha)"
  local -r tag="${sha:0:7}"
  local -r fake_sha="CYBER_DOJO_START_POINTS_BASE_SHA=${sha}"
  local -r fake_tag="CYBER_DOJO_START_POINTS_BASE_TAG=${tag}"
  docker rm --force fake_versioner > /dev/null 2>&1 | true
  docker run --detach --name fake_versioner alpine:latest sh -c 'mkdir /app' > /dev/null
  echo "${env_vars}" >  /tmp/.env
  echo "${fake_sha}" >> /tmp/.env # replaces earlier entry when exported
  echo "${fake_tag}" >> /tmp/.env # replaces earlier entry when exported
  docker cp /tmp/.env fake_versioner:/app/.env
  docker commit fake_versioner cyberdojo/versioner:latest > /dev/null 2>&1
  docker rm --force fake_versioner > /dev/null 2>&1
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${ROOT_DIR}" && git rev-parse HEAD)
}

# - - - - - - - - - - - - - - - - - - - - - - - -
source ${ROOT_DIR}/sh/cat_env_vars.sh
build_fake_versioner "$(cat_env_vars)"
# show it...
docker run --rm -it ${fake_image} sh -c 'cat /app/.env' | tail -n -2
echo "${fake_sha}:"
echo "${fake_tag}:"
