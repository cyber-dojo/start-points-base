FROM ghcr.io/cyber-dojo/sinatra-base:ac5f6a7@sha256:e74f2c4f8d2f8fa6504c7d044fd2ed6692c40a735c144d07e06cea38edfefccd AS base
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
