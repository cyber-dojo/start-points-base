#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly IMAGE_NAME=cyberdojo/start-points

# create git repo from test-data
readonly TMP_DIR=$(mktemp -d /tmp/cyber-dojo-start-point-exercises.XXXXXXXXX)
#cleanup() { rm -rf "${TMP_DIR}" > /dev/null; }
#trap cleanup EXIT
readonly TARGET_DIR="${ROOT_DIR}/test/data/exercises"
cp -R "${TARGET_DIR}/" "${TMP_DIR}"
cd "${TARGET_DIR}" && git init && git add . && git commit -m "initial commit"
exit 1

# build the FROM image so it won't be docker pulled
docker build \
  --tag cyberdojo/start-points-base \
  "${ROOT_DIR}"

# smoke test building an image
"${ROOT_DIR}/${SCRIPT}" \
  ${IMAGE_NAME} \
    https://github.com/cyber-dojo/start-points-languages.git \
    https://github.com/cyber-dojo/start-points-custom.git    \




    #https://github.com/cyber-dojo/start-points-exercises.git \
