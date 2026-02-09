FROM ghcr.io/cyber-dojo/sinatra-base:71fcca8@sha256:8ff599728e607da61bf9237f8aa48d55eb0fd0df27205ed4a90e5f7b0626163e
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
