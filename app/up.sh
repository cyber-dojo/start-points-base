#!/bin/bash -Eeu

if [ -z "${PORT}" ]; then
  echo "PORT environment variable not set"
  exit 42
fi

rackup             \
  --env production \
  --host 0.0.0.0   \
  --port "${PORT}" \
  --server thin    \
  --warn           \
    /app/config.ru
