FROM ghcr.io/cyber-dojo/sinatra-base:5997b3d@sha256:9e454262ad7af06b00916d49256aa85b87e950f4eed601dce8bf9a627f83510a AS base
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
