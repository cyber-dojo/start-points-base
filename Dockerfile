FROM ghcr.io/cyber-dojo/sinatra-base:3ce6c9b@sha256:7e53acc4239e11722997e85367eb8e995d995ceec05f1cc6430da989bb09b108
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
