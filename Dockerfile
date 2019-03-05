ARG docker_arch=amd64
FROM $docker_arch/debian:stretch-slim
ARG qemu_arch="./qemu-x86_64-static"
ARG docker_arch=amd64
MAINTAINER Adam Harrison-Fuller <adam@adamhf.io>
COPY ${qemu_arch} /usr/bin/

RUN apt-get update && \
    apt-get install -y mumble-server && \
    rm -rf \
    /var/cache/apt/* \
    /var/lib/apt/lists/*

EXPOSE 64738 64738/udp

ADD ./data/mumble_server.ini /config-orig/
RUN mkdir /config
VOLUME /data
ENV MUMBLE_INI /config/mumble_server.ini

ADD entrypoint.sh /
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-fg"]
