FROM cyberdojo/sinatra-base:9b39ce0@sha256:217226b001970ff0bcf3e1edc52710534cf6e664dac9aac8b882c2b514e41edd
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
