FROM ghcr.io/cyber-dojo/sinatra-base:c58736f@sha256:35f8f0ad8bf53b955398392891ca64949787d414edb53789be8a628d76f6d217
LABEL maintainer=jon@jaggersoft.com

RUN apk --update --upgrade add git
COPY --chown=nobody:nogroup . /app
USER root
ENTRYPOINT [ "/app/create_data_set.sh" ]
