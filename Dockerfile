FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

WORKDIR /app
COPY . .
RUN chown -R nobody:nogroup .

ARG BASE_SHA
ENV BASE_SHA=${BASE_SHA}

USER nobody
