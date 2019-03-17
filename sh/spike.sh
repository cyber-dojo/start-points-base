#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly REPO_DIR=/Users/jonjagger/repos

${MY_DIR}/build_base_docker_image.sh

${MY_DIR}/../cyber_dojo_start_points_create.sh \
  acme/spc \
    --custom \
      file://${REPO_DIR}/cyber-dojo/start-points-custom

${MY_DIR}/../cyber_dojo_start_points_create.sh \
  acme/spe \
    --exercises \
      file://${REPO_DIR}/cyber-dojo/start-points-exercises

${MY_DIR}/../cyber_dojo_start_points_create.sh \
  acme/spl4 \
    --languages \
      file://${REPO_DIR}/cyber-dojo-languages/ruby-minitest \
      file://${REPO_DIR}/cyber-dojo-languages/ruby-testunit \
      file://${REPO_DIR}/cyber-dojo-languages/gcc-assert \
      file://${REPO_DIR}/cyber-dojo-languages/python-pytest

${MY_DIR}/../../web/sh/build_docker_images.sh
${MY_DIR}/../../commander/sh/build_docker_images.sh

${MY_DIR}/../../commander/cyber-dojo \
  up \
    --custom=acme/spc \
    --exercises=acme/spe \
    --languages=acme/spl4 \
