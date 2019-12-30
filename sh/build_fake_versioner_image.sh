#!/bin/bash -Eeu

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

# - - - - - - - - - - - - - - - - - - - - - - - -
build_fake_versioner()
{
  local env_vars="${1}"
  local -r fake_sha="$(git_commit_sha)"
  local -r fake_tag="${fake_sha:0:7}"
  local -r fake=fake_versioner

  docker rm --force "${fake}" > /dev/null 2>&1 | true
  docker run                  \
    --detach                  \
    --env RELEASE=999.999.999 \
    --env SHA="${sha}"        \
    --name "${fake}"          \
    alpine:latest             \
      sh -c 'mkdir /app' > /dev/null

  # replace START_POINTS_BASE env-vars with fakes
  env_vars=$(echo "${env_vars}" | grep --invert-match CYBER_DOJO_START_POINTS_BASE_SHA)
  env_vars=$(echo "${env_vars}" | grep --invert-match CYBER_DOJO_START_POINTS_BASE_TAG)
  echo "${env_vars}" >  /tmp/.env
  echo "CYBER_DOJO_START_POINTS_BASE_SHA=${fake_sha}" >> /tmp/.env
  echo "CYBER_DOJO_START_POINTS_BASE_TAG=${fake_tag}" >> /tmp/.env
  docker cp /tmp/.env "${fake}:/app/.env"
  docker commit "${fake}" cyberdojo/versioner:latest > /dev/null 2>&1
  docker rm --force "${fake}" > /dev/null 2>&1
  # check it
  expected="CYBER_DOJO_START_POINTS_BASE_SHA=${fake_sha}"
  actual=$(docker run --rm cyberdojo/versioner:latest sh -c 'cat /app/.env' | grep CYBER_DOJO_START_POINTS_BASE_SHA)
  assert_equal "${expected}" "${actual}"

  expected="CYBER_DOJO_START_POINTS_BASE_TAG=${fake_tag}"
  actual=$(docker run --rm cyberdojo/versioner:latest sh -c 'cat /app/.env' | grep CYBER_DOJO_START_POINTS_BASE_TAG)
  assert_equal "${expected}" "${actual}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
assert_equal()
{
  local -r expected="${1}"
  local -r actual="${2}"
  if [ "${expected}" != "${actual}" ]; then
    echo "ERROR"
    echo "expected:${expected}"
    echo "  actual:${actual}"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${ROOT_DIR}" && git rev-parse HEAD)
}

# - - - - - - - - - - - - - - - - - - - - - - - -
source ${ROOT_DIR}/sh/cat_env_vars.sh
build_fake_versioner "$(cat_env_vars)"
