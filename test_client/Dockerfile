FROM cyberdojo/docker-base:d0da6ee
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

EXPOSE 4528
USER nobody
CMD [ "/app/up.sh" ]
