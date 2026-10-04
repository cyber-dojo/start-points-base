FROM ghcr.io/cyber-dojo/sinatra-base:a44535c@sha256:05aa5db570c04923a5076f86e14a87bd994cd4fd0ea866cd9866f070e472a727 AS base
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
