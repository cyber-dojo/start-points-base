FROM ghcr.io/cyber-dojo/sinatra-base:c58736f@sha256:35f8f0ad8bf53b955398392891ca64949787d414edb53789be8a628d76f6d217 AS base
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

EXPOSE 4528
USER nobody
CMD [ "/app/up.sh" ]
