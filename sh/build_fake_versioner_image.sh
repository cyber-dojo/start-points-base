#!/bin/bash -Eeu

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

# - - - - - - - - - - - - - - - - - - - - - - - -
build_fake_versioner()
{
  local -r sha_var_name=CYBER_DOJO_START_POINTS_BASE_SHA
  local -r tag_var_name=CYBER_DOJO_START_POINTS_BASE_TAG

  local -r fake_sha="$(git_commit_sha)"
  local -r fake_tag="${fake_sha:0:7}"

  local env_vars="${1}"
  env_vars=$(replace_with "${env_vars}" "${sha_var_name}" "${fake_sha}")
  env_vars=$(replace_with "${env_vars}" "${tag_var_name}" "${fake_tag}")

  local -r fake_container=fake_versioner
  local -r fake_image=cyberdojo/versioner:latest

  docker rm --force "${fake_container}" > /dev/null 2>&1 | true
  docker run                   \
    --detach                   \
    --env RELEASE=999.999.999  \
    --env SHA="${fake_sha}"    \
    --name "${fake_container}" \
    alpine:latest              \
      sh -c 'mkdir /app' > /dev/null

  echo "${env_vars}" >  /tmp/.env
  docker cp /tmp/.env "${fake_container}:/app/.env"
  docker commit "${fake_container}" "${fake_image}" > /dev/null 2>&1
  docker rm --force "${fake_container}" > /dev/null 2>&1

  # check it
  expected="${sha_var_name}=${fake_sha}"
  actual=$(docker run --rm "${fake_image}" sh -c 'cat /app/.env' | grep "${sha_var_name}")
  assert_equal "${expected}" "${actual}"

  expected="${tag_var_name}=${fake_tag}"
  actual=$(docker run --rm "${fake_image}" sh -c 'cat /app/.env' | grep "${tag_var_name}")
  assert_equal "${expected}" "${actual}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
replace_with()
{
  local -r env_vars="${1}"
  local -r name="${2}"
  local -r fake_value="${3}"
  local -r all_except=$(echo "${env_vars}" | grep --invert-match "${name}")
  printf "${all_except}\n${name}=${fake_value}\n"
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
