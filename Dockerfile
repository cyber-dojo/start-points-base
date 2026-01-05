FROM ghcr.io/cyber-dojo/sinatra-base:a8e581e@sha256:61a896d3ff86385c89baa0cb61500c93a8fcfb216ca76cdb774e5c32d2ff2d04
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
