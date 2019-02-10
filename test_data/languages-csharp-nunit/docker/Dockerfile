FROM  cyberdojofoundation/csharp
LABEL maintainer=jon@jaggersoft.com

COPY packages.config .

ADD install.sh /
RUN /install.sh && rm -f /install.sh

COPY red_amber_green.rb /usr/local/bin
