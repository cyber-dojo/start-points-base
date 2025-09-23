FROM ghcr.io/cyber-dojo/sinatra-base:d514be3@sha256:5c3ac8ad71245c296a5fb44a20deab9515cdffe1e27a8343060932497f8102d1
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
