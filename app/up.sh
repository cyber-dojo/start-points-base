#!/bin/bash -Eeu

readonly MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "${PORT:-}" ]; then
  echo "PORT environment variable not set"
  exit 42
fi

export RUBYOPT='-W2'

puma \
  --port=${PORT} \
  --config=${MY_DIR}/puma.rb
