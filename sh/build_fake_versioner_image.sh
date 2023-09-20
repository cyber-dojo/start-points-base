#!/usr/bin/env bash
set -Eeu

readonly TMP_DIR="$(mktemp -d /tmp/start-points-base.XXXXXXX)"
remove_TMP_DIR() { rm -rf "${TMP_DIR} > /dev/null"; }
trap remove_TMP_DIR INT EXIT

# Other cyber-dojo repos overwrite specific cyberdojo/versioner env-vars
# by having an echo_versioner_env_vars function that runs cyberdojo/versioner
# and then overwrites the env-vars that need to be stubbed with trailing
# explicit echo statements. Then they set all the env-vars by doing a:
#   $ export "$(echo_versioner_env_vars)"
# Eg, see https://github.com/cyber-dojo/web/blob/main/sh/echo_versioner_env_vars.sh
#
# We can't do that for the this repo because this repo's tests
# make calls to commander's top-level cyberdojo script, to run
#   $ cyber-dojo start-point create <NAME> --custom <URL>...
# and commander's /app/sh/cat-start-point-create.sh does a
#   $ readonly ENV_VARS="$(docker run --entrypoint=cat --rm cyberdojo/versioner:latest /app/.env)"

# - - - - - - - - - - - - - - - - - - - - - - - -
build_fake_versioner_image()
{
  # Build a fake cyberdojo/versioner:latest image that serves
  # CYBER_DOJO_START_POINTS_BASE SHA/TAG values for the local repo.
  local env_vars="$(docker run --rm cyberdojo/versioner:latest)"

  local -r spb_sha_var_name=CYBER_DOJO_START_POINTS_BASE_SHA
  local -r spb_tag_var_name=CYBER_DOJO_START_POINTS_BASE_TAG
  local -r spb_fake_sha="$(git_commit_sha)"
  local -r spb_fake_tag="${spb_fake_sha:0:7}"
  env_vars=$(replace_with "${env_vars}" "${spb_sha_var_name}" "${spb_fake_sha}")
  env_vars=$(replace_with "${env_vars}" "${spb_tag_var_name}" "${spb_fake_tag}")

  # For debugging; there is a circular dependency on commander
  local -r comm_sha_var_name=CYBER_DOJO_COMMANDER_SHA
  local -r comm_tag_var_name=CYBER_DOJO_COMMANDER_TAG
  local -r comm_fake_sha="ca4c5e8e8d9bcc508c9075314e746463d1d982e6"
  local -r comm_fake_tag="${comm_fake_sha:0:7}"
  env_vars=$(replace_with "${env_vars}" "${comm_sha_var_name}" "${comm_fake_sha}")
  env_vars=$(replace_with "${env_vars}" "${comm_tag_var_name}" "${comm_fake_tag}")

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
    --build-arg SHA="${spb_fake_sha}" \
    --build-arg RELEASE=999.999.999 \
    --tag "${fake_image}" \
    "${TMP_DIR}"

  echo "Checking fake ${fake_image}"

  # CYBER_DOJO_START_POINTS_BASE
  expected="${spb_sha_var_name}=${spb_fake_sha}"
  actual=$(docker run --rm "${fake_image}" | grep "${spb_sha_var_name}")
  assert_equal "${expected}" "${actual}" CYBERDOJO_START_POINTS_BASE_SHA

  expected="${spb_tag_var_name}=${spb_fake_tag}"
  actual=$(docker run --rm "${fake_image}" | grep "${spb_tag_var_name}")
  assert_equal "${expected}" "${actual}" CYBERDOJO_START_POINTS_BASE_TAG

  # CYBER_DOJO_COMMANDER
  expected="${comm_sha_var_name}=${comm_fake_sha}"
  actual=$(docker run --rm "${fake_image}" | grep "${comm_sha_var_name}")
  assert_equal "${expected}" "${actual}" CYBER_DOJO_COMMANDER_SHA

  expected="${comm_tag_var_name}=${comm_fake_tag}"
  actual=$(docker run --rm "${fake_image}" | grep "${comm_tag_var_name}")
  assert_equal "${expected}" "${actual}" CYBER_DOJO_COMMANDER_TAG

  # RELEASE
  expected=RELEASE='999.999.999'
  actual=RELEASE=$(docker run --entrypoint "" --rm "${fake_image}" sh -c 'echo ${RELEASE}')
  assert_equal "${expected}" "${actual}" RELEASE

  # SHA
  expected=SHA="${spb_fake_sha}"
  actual=SHA=$(docker run --entrypoint "" --rm "${fake_image}" sh -c 'echo ${SHA}')
  assert_equal "${expected}" "${actual}" SHA
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
  local -r message="${3}"

  if [ "${expected}" == "${actual}" ]; then
    echo "asserted: '${expected}'"
  else
    echo "ERROR: assert_equal failed: ${message}"
    echo "expected: '${expected}'"
    echo "  actual: '${actual}'"
    exit 42
  fi
}

