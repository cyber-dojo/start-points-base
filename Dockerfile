FROM  cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

ARG                            HOME=/app
COPY .                       ${HOME}
RUN  chown -R nobody:nogroup ${HOME}

EXPOSE 4547
USER nobody
CMD [ "./up.sh" ]
