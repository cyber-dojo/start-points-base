FROM ghcr.io/cyber-dojo/sinatra-base:dd38f41@sha256:78e366649c6b28379a7666503149d71aa154960b9421e8a57721da13c1eb7ab1
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
