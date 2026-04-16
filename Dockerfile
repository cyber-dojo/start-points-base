FROM ghcr.io/cyber-dojo/sinatra-base:1b1df8e@sha256:0cf1c46e55c2c66cb7c55724f405784364be1d18cb7a2f47f6f0abf1cee0a80d
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
