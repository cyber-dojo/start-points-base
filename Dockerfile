FROM ghcr.io/cyber-dojo/sinatra-base:b3ab6b8@sha256:b60cc87eb0a33ff0f2bab245a89c0c6a00430f3eedb011a39a97bf0cf1163ee2
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
