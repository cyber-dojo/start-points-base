FROM ghcr.io/cyber-dojo/sinatra-base:1200d3b@sha256:7c4eb39e9b9de9b49f8fc650e47fac58bff984fe50198ab51d8fbdf623d4cc3f AS base
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
