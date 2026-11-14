FROM ghcr.io/cyber-dojo/sinatra-base:7821b64@sha256:811b16d35ee135e176bdaa61ce1b9a44f5beb307c979dd451cda8b2afe7b4b1d AS base
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
