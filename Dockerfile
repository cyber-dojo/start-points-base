FROM cyberdojo/sinatra-base:018d494@sha256:09714ffbd53803a2f67fe1332c0feb8e7f73e49516a6c8136137269b3b715691
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
