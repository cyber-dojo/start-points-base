#!/usr/bin/env bash
set -Eeu

versioner_env_vars()
{
  docker run --rm cyberdojo/versioner:latest
}
