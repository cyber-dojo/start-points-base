FROM ghcr.io/cyber-dojo/sinatra-base:c58736f@sha256:35f8f0ad8bf53b955398392891ca64949787d414edb53789be8a628d76f6d217 AS base
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
