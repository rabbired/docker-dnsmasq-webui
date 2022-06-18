FROM alpine:latest
LABEL maintainer="rabbired@outlook.com"

RUN apk update && apk upgrade \
    && apk --no-cache add dnsmasq bash \
    && apk add --no-cache --virtual .build-deps curl \
    && curl https://i.jpillora.com/webproc | bash \
    && mv -f webproc /usr/local/bin/ \
    && chmod +x /usr/local/bin/webproc \
    && apk del .build-deps bash

RUN mkdir -p /etc/default/ /data/ && mv /etc/dnsmasq.conf /data/ \
    && echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq \
    && rm -rf /var/cache/apk/* \
    && rm -rf /root/.cache \
    && rm -rf /tmp/*

ENTRYPOINT ["webproc","--configuration-file","/data/dnsmasq.conf","--","dnsmasq","--no-daemon"]
