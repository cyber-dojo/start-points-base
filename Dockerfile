FROM ghcr.io/cyber-dojo/sinatra-base:afd3580@sha256:9f037f66b3edc6b644d688d76a5cf624ab60751f0b14947de1237686c5776b1f
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
