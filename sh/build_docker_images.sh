#!/bin/bash

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

# will be needed when client side tests are in place...

docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  build
