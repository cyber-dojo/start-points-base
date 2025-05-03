FROM cyberdojo/sinatra-base:9096653@sha256:dd4c1615e7f8ae91a50cd4bb31cfdd82ffb556929be1f809ea1ce0a0d819b8ff
# The FROM statement above is typically set via an automated pull-request from from sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
