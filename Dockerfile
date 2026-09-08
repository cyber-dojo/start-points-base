FROM ghcr.io/cyber-dojo/sinatra-base:949edc1@sha256:fd5205d77df654e812682c185b04f8c94f22ae192d2a09efb68f1358a36d73a2 AS base
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
