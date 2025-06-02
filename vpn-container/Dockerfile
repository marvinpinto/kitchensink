# vim: set filetype=dockerfile :

FROM ghcr.io/linuxserver/baseimage-alpine:3.22
LABEL org.opencontainers.image.source=https://github.com/marvinpinto/kitchensink
LABEL org.opencontainers.image.description="VPN + SOCKS5 Proxy Container"
LABEL org.opencontainers.image.licenses=MIT

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# base requirements
RUN apk add --no-cache --update openssl \
    ca-certificates \
    iptables \
    iptables-legacy \
    tzdata \
    wget \
    busybox && \
  rm -rf /var/cache/apk/* && \
  mkdir /gluetun

# openvpn tweaks taken from https://github.com/qdm12/gluetun/blob/v3.38.0/Dockerfile
RUN apk add --no-cache --update -l wget && \
  apk add --no-cache --update -X "https://dl-cdn.alpinelinux.org/alpine/v3.17/main" openvpn\~2.5 && \
  mv /usr/sbin/openvpn /usr/sbin/openvpn2.5 && \
  apk del openvpn && \
  apk add --no-cache --update openvpn && \
  mv /usr/sbin/openvpn /usr/sbin/openvpn2.6 && \
  rm -rf /var/cache/apk/* /etc/openvpn/*.sh /usr/lib/openvpn/plugins/openvpn-plugin-down-root.so && \
  deluser openvpn

COPY --from=docker.io/qmcgaw/gluetun:v3.40.0 /gluetun-entrypoint /usr/local/bin/gluetun
COPY --from=ghcr.io/shadowsocks/sslocal-rust:v1.21.2 /usr/bin/sslocal /usr/local/bin/sslocal
COPY root/ /
COPY dnsbl-checker.py /etc/

# gluetun config (to keep servers.json updated)
VOLUME /gluetun

# shadowsocks
EXPOSE 8388/tcp 8388/udp

# socks5
EXPOSE 8888/tcp 8888/udp

ENTRYPOINT ["/init"]
