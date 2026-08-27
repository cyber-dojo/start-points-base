#!/usr/bin/env bash
set -Eeu

readonly MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export RUBYOPT=-w

puma \
  --port=4528 \
  --config=${MY_DIR}/puma.rb
