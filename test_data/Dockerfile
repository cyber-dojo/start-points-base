FROM cyberdojo/ruby-base:0644024
LABEL maintainer=jon@jaggersoft.com

RUN apk --update --upgrade add git
COPY --chown=nobody:nogroup . /app
USER root
ENTRYPOINT [ "/app/create_data_set.sh" ]
