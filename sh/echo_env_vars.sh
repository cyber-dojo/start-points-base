#!/usr/bin/env bash
set -Eeu

echo_env_vars()
{
  docker --log-level=ERROR run --rm cyberdojo/versioner:latest 2> /dev/null
}
