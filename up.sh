#!/bin/bash

rackup             \
  --env production \
  --host 0.0.0.0   \
  --port 4527      \
  --server thin    \
  --warn           \
    config.ru
