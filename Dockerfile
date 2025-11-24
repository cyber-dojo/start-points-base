FROM ghcr.io/cyber-dojo/sinatra-base:ba7acf3@sha256:8baa0ce05142cf89a9333bf0f5a1e6cfd9e2ce0c6b6e4464403410a3ab32c9f5
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
