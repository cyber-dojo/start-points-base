#!/usr/bin/env bash
set -Eeu

readonly MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "${PORT:-}" ]; then
  echo "PORT environment variable not set"
  exit 42
fi

# Ruby 4.0 increased the default YJIT memory limit from 48MB to 128MB per process.
# Without this, the service is OOM-killed in aws-prod. Restore the 3.3.x default.
export RUBYOPT='-W2 --yjit-mem-size=48'

puma \
  --port=${PORT} \
  --config=${MY_DIR}/puma.rb
