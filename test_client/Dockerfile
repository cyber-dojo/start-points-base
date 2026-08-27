FROM ghcr.io/cyber-dojo/sinatra-base:5ab6a10@sha256:c096154011cc1cef9cc69e8be948fb4329543f9670d4fb4fd3851a8aa016630d AS base
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

EXPOSE 4528
USER nobody
CMD [ "/app/up.sh" ]
