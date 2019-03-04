FROM debian:stretch-slim
MAINTAINER Adam Harrison-Fuller <adam@adamhf.io>

RUN apt-get update && \
    apt-get install -y mumble-server && \
    rm -rf \
    /var/cache/apt/* \
    /var/lib/apt/lists/*

EXPOSE 64738 64738/udp

ADD ./data/mumble_server.ini /config/
VOLUME /data
ENV MUMBLE_INI /config/mumble_server.ini

ADD entrypoint.sh /
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-fg"]
