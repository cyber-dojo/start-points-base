FROM cyberdojo/sinatra-base:47dfdfc@sha256:662cbdca2af4ce4031873f3f8e2a6d9b9ae720f51d2b98422764a6d556f0b7f6
# The FROM statement above is typically set via an automated pull-request from from sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
