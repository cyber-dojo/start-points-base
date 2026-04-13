FROM ghcr.io/cyber-dojo/sinatra-base:a2408d5@sha256:d0d4d7f9c44500a5fae8275e777658ac9d2b09ea44e0313a4a56d698437da3e7
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
