FROM cyberdojo/sinatra-base:1552fae@sha256:402680b4f08344ee965c5905915b209e28fb469dd39c8d0854c1a0d109b78882
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
