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

ONBUILD COPY . /app/repos
ONBUILD RUN ruby /app/src/check_all.rb /app/repos
