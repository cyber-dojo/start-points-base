#FROM alpine:latest
FROM cyberdojo/differ
LABEL maintainer=jon@jaggersoft.com

#RUN apk --update --upgrade add git
WORKDIR /app
COPY . .
USER root
RUN chown -R nobody:nogroup .
USER nobody
ENTRYPOINT [ "/app/cp_data_set.sh" ]
