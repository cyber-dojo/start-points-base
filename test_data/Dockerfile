FROM alpine:latest
LABEL maintainer=jon@jaggersoft.com

RUN apk --update --upgrade --no-cache add git
WORKDIR /app
COPY . .
RUN chown -R nobody:nogroup .

USER nobody
