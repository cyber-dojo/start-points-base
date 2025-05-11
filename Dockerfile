FROM cyberdojo/sinatra-base:d45cfbd@sha256:7cb47803e76b8958eb55df4f7470e30245b97e6481a4103c6fee8dc8b5c96045
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
