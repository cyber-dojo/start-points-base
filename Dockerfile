FROM ghcr.io/cyber-dojo/sinatra-base:28b632a@sha256:41f5d307193f8c917082ee23443cf4fdf0b17af249522e0495030a413c8b9bcd
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
