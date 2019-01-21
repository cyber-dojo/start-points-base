FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

WORKDIR /app
COPY . .
RUN chown -R nobody:nogroup .

ARG SHA
ENV SHA=${SHA}

EXPOSE 4527
USER nobody
CMD [ "./up.sh" ]
