ARG BASE_IMAGE=cyberdojo/sinatra-base:e124088
FROM ${BASE_IMAGE}
# ARGs are reset after FROM See https://github.com/moby/moby/issues/34129
ARG BASE_IMAGE
ENV BASE_IMAGE=${BASE_IMAGE}
LABEL maintainer=jon@jaggersoft.com

WORKDIR /app
COPY . .

ARG BASE_SHA
ENV BASE_SHA=${BASE_SHA}

HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
