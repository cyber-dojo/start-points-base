FROM alpine:latest
LABEL maintainer=jon@jaggersoft.com

RUN apk --update --upgrade add bash git
WORKDIR /app
COPY . .
RUN chown -R nobody:nogroup .
USER nobody
ENTRYPOINT [ "/app/cp_data_set.sh" ]
