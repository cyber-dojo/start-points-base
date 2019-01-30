FROM alpine:latest
LABEL maintainer=jon@jaggersoft.com

RUN apk --update --upgrade add git
WORKDIR /app
COPY . .
RUN chown -R nobody:nogroup .

USER nobody

ENTRYPOINT [ "/app/setup_data_set.sh" ]
