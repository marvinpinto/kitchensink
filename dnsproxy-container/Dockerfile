# vim: set filetype=dockerfile :

FROM ghcr.io/linuxserver/baseimage-alpine:3.23
LABEL org.opencontainers.image.source https://github.com/marvinpinto/kitchensink
LABEL org.opencontainers.image.description="DNS Proxy Container"
LABEL org.opencontainers.image.licenses=MIT

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# base requirements
RUN apk add --no-cache --update \
  openssl && \
  rm -rf /var/cache/apk/*

COPY --from=ghcr.io/shadowsocks/sslocal-rust:v1.18.2 /usr/bin/sslocal /usr/local/bin/sslocal
COPY --from=ghcr.io/shadowsocks/ssserver-rust:v1.18.2 /usr/bin/ssserver /usr/local/bin/ssserver
COPY root/ /

# socks5
EXPOSE 8888/tcp 8888/udp

ENTRYPOINT ["/init"]
