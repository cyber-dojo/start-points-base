FROM cyberdojo/ruby-base:d945333
LABEL maintainer=jon@jaggersoft.com

RUN apk --update --upgrade add git
COPY --chown=nobody:nogroup . /app
USER root
ENTRYPOINT [ "/app/create_data_set.sh" ]
