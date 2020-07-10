#!/bin/bash -Eeu

readonly MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "${PORT:-}" ]; then
  echo "PORT environment variable not set"
  exit 42
fi

rackup             \
  --env production \
  --host 0.0.0.0   \
  --port "${PORT}" \
  --server thin    \
  --warn           \
    "${MY_DIR}/config.ru"
