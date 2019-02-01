FROM cyberdojo/ruby-base
LABEL maintainer=jon@jaggersoft.com

RUN apk --update --upgrade add git
WORKDIR /app
COPY . .
RUN chown -R nobody:nogroup .
USER root
ENTRYPOINT [ "/app/create_data_set.sh" ]
