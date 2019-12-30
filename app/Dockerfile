FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

ARG BASE_SHA
ENV BASE_SHA=${BASE_SHA}

USER nobody
