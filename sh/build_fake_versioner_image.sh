#!/bin/bash -Eeu

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly TMP_DIR="$(mktemp -d /tmp/start-points-base.XXXXXXX)"
remove_TMP_DIR() { rm -rf "${TMP_DIR} > /dev/null"; }
trap remove_TMP_DIR INT EXIT

# - - - - - - - - - - - - - - - - - - - - - - - -
build_fake_versioner()
{
  # Build a fake cyberdojo/versioner:latest image that serves
  # CYBER_DOJO_START_POINTS_BASE SHA/TAG values for the local repo.  
  local -r sha_var_name=CYBER_DOJO_START_POINTS_BASE_SHA
  local -r tag_var_name=CYBER_DOJO_START_POINTS_BASE_TAG

  local -r fake_sha="$(git_commit_sha)"
  local -r fake_tag="${fake_sha:0:7}"

  local env_vars="$(docker run --rm cyberdojo/versioner:latest)"
  env_vars=$(replace_with "${env_vars}" "${sha_var_name}" "${fake_sha}")
  env_vars=$(replace_with "${env_vars}" "${tag_var_name}" "${fake_tag}")

  echo "${env_vars}" > ${TMP_DIR}/.env
  local -r fake_image=cyberdojo/versioner:latest
  {
    echo 'FROM alpine:latest'
    echo 'COPY . /app'
    echo 'ARG SHA'
    echo 'ENV SHA=${SHA}'
    echo 'ARG RELEASE'
    echo 'ENV RELEASE=${RELEASE}'
    echo 'ENTRYPOINT [ "cat", "/app/.env" ]'
  } > ${TMP_DIR}/Dockerfile
  docker build \
    --build-arg SHA="${fake_sha}" \
    --build-arg RELEASE=999.999.999 \
    --tag "${fake_image}" \
    "${TMP_DIR}"

  echo "Checking fake ${fake_image}"

  expected="${sha_var_name}=${fake_sha}"
  actual=$(docker run --rm "${fake_image}" | grep "${sha_var_name}")
  assert_equal "${expected}" "${actual}"

  expected="${tag_var_name}=${fake_tag}"
  actual=$(docker run --rm "${fake_image}" | grep "${tag_var_name}")
  assert_equal "${expected}" "${actual}"

  expected='RELEASE=999.999.999'
  actual=RELEASE=$(docker run --entrypoint "" --rm "${fake_image}" sh -c 'echo ${RELEASE}')
  assert_equal "${expected}" "${actual}"

  expected="SHA=${fake_sha}"
  actual=SHA=$(docker run --entrypoint "" --rm "${fake_image}" sh -c 'echo ${SHA}')
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
  echo "expected: '${expected}'"
  echo "  actual: '${actual}'"
  if [ "${expected}" != "${actual}" ]; then
    echo "ERROR: assert_equal failed"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${ROOT_DIR}" && git rev-parse HEAD)
}

# - - - - - - - - - - - - - - - - - - - - - - - -
source ${ROOT_DIR}/sh/versioner_env_vars.sh
build_fake_versioner "$(versioner_env_vars)"
