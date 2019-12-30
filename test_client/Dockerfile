FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

COPY --chown=nobody:nogroup . /app

EXPOSE 4528
USER nobody
CMD [ "/app/up.sh" ]
