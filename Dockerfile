FROM ghcr.io/cyber-dojo/sinatra-base:c7abc15@sha256:dd692d91c186a4ca225ae2b778d251cdd8d52d0e8cb035668d7b5fa906a10ee4
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
