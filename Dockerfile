FROM ghcr.io/cyber-dojo/sinatra-base:71c8bf4@sha256:32bbd86e4b8860d9a3ab89b233a9a8887bd404e824293b323e7a42ff5af87163
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
