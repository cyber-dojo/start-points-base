FROM ghcr.io/cyber-dojo/sinatra-base:4eba88f@sha256:5250025235427e5458349654003c3791f2dc9d3dbdc10e6b80dbb101b57a6b6e AS base
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
