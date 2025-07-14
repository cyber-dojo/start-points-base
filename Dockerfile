FROM cyberdojo/sinatra-base:d58b8c5@sha256:d5d5e239fd9cef0a192bfdc23d56d2eccd24159fc65f84147dbcf75e2002e11a
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
