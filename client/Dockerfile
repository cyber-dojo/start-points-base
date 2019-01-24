FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

WORKDIR /app
COPY . .
RUN chown -R nobody:nogroup .

EXPOSE 4528
USER nobody
CMD [ "./up.sh" ]
