#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

export DONT_PULL_START_POINTS_BASE=true
${MY_DIR}/build_base_docker_image.sh

${MY_DIR}/../cyber_dojo_start_points_create.sh \
  acme/spc \
    --custom \
      file:///Users/jonjagger/repos/cyber-dojo/start-points-custom

${MY_DIR}/../cyber_dojo_start_points_create.sh \
  acme/spe \
    --exercises \
      file:///Users/jonjagger/repos/cyber-dojo/start-points-exercises

${MY_DIR}/../cyber_dojo_start_points_create.sh \
  acme/spl4 \
    --languages \
      file:///Users/jonjagger/repos/cyber-dojo-languages/ruby-minitest \
      file:///Users/jonjagger/repos/cyber-dojo-languages/ruby-testunit \
      file:///Users/jonjagger/repos/cyber-dojo-languages/gcc-assert \
      file:///Users/jonjagger/repos/cyber-dojo-languages/python-pytest

${MY_DIR}/../../web/sh/build_docker_images.sh
${MY_DIR}/../../commander/sh/build_docker_images.sh

${MY_DIR}/../../commander/cyber-dojo \
  up \
    --languages=acme/spl4 \
