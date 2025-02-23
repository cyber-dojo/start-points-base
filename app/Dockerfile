FROM cyberdojo/sinatra-base:97cbc87@sha256:fcd7994b7d6c2a7545bbaf99367d874f060f999e0257cb03528bfe0d0e446cb2
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

WORKDIR /app
COPY . .
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
