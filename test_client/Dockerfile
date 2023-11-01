FROM cyberdojo/docker-base:103fe8d
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

EXPOSE 4528
USER nobody
CMD [ "/app/up.sh" ]
