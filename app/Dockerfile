FROM cyberdojo/docker-base:d0da6ee
LABEL maintainer=jon@jaggersoft.com

WORKDIR /app
COPY . .

ARG BASE_SHA
ENV BASE_SHA=${BASE_SHA}

HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
