FROM cyberdojo/sinatra-base:4dadf50@sha256:867aad18632fd86f25fe5ef9205d0ed37e615f172ac47847cda0452c3c85518d
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
