#!/usr/bin/env bash
set -Eeu

readonly TMP_DIR="$(mktemp -d /tmp/start-points-base.XXXXXXX)"
remove_TMP_DIR() { rm -rf "${TMP_DIR} > /dev/null"; }
trap remove_TMP_DIR INT EXIT

# Other cyber-dojo repos overwrite specific cyberdojo/versioner env-vars
# by having an echo_env_vars function that runs cyberdojo/versioner
# and then overwrites the env-vars that need to be stubbed with trailing
# explicit echo statements. Then they set all the env-vars by doing a:
#   $ export $(echo_env_vars)
# Eg, see https://github.com/cyber-dojo/web/blob/main/sh/echo_env_vars.sh
#
# We can't do that for the this repo because this repo's tests
# make calls to commander's top-level cyberdojo script, to run
#   $ cyber-dojo start-point create <NAME> --custom <URL>...
# and commander's /app/sh/cat-start-point-create.sh does a
#   $ readonly ENV_VARS="$(docker run --entrypoint=cat --rm cyberdojo/versioner:latest /app/.env)"
# so we need that cyberdojo/versioner:latest to be the fake one

debug_commander()
{
  # For debugging; there is a circular dependency on commander.
  # If you have a locally built commander image you wish to use
  # make this function return true, and set commander_fake_sha to its commit-sha below

  return 1 # false
  # return 0 # true
}

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

  if debug_commander; then
    local -r commander_sha_var_name=CYBER_DOJO_COMMANDER_SHA
    local -r commander_tag_var_name=CYBER_DOJO_COMMANDER_TAG
    local -r commander_fake_sha="dbac9a5a2ce3b8577bc7e2af397d45536886c234"
    local -r commander_fake_tag="${commander_fake_sha:0:7}"
    env_vars=$(replace_with "${env_vars}" "${commander_sha_var_name}" "${commander_fake_sha}")
    env_vars=$(replace_with "${env_vars}" "${commander_tag_var_name}" "${commander_fake_tag}")
  fi

  echo "${env_vars}" > ${TMP_DIR}/.env
  local -r fake_image=cyberdojo/versioner:latest
  {
    echo 'FROM alpine:latest'
    echo 'ARG SHA'
    echo 'ENV SHA=${SHA}'
    echo 'ARG RELEASE'
    echo 'ENV RELEASE=${RELEASE}'
    echo 'COPY . /app'
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

  if debug_commander; then
    expected="${commander_sha_var_name}=${commander_fake_sha}"
    actual=$(docker run --rm "${fake_image}" | grep "${commander_sha_var_name}")
    assert_equal "${expected}" "${actual}" CYBER_DOJO_COMMANDER_SHA

    expected="${commander_tag_var_name}=${commander_fake_tag}"
    actual=$(docker run --rm "${fake_image}" | grep "${commander_tag_var_name}")
    assert_equal "${expected}" "${actual}" CYBER_DOJO_COMMANDER_TAG
  fi

  # RELEASE
  expected=RELEASE='999.999.999'
  actual=RELEASE=$(docker run --entrypoint "" --rm "${fake_image}" sh -c 'echo ${RELEASE}')
  assert_equal "${expected}" "${actual}" RELEASE
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

