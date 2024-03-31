# VPN + SOCKS5 Proxy Container

This container combines [gluetun](https://github.com/qdm12/gluetun) & [shadowsocks](https://github.com/shadowsocks/shadowsocks-rust) and allows use a local socks5 proxy to tunnel over a VPN connection. It supports all the config variables gluetun supports.

It exposes port 8888 for the SOCKS5 proxy, and port 8388 if you wanted to connect to the gluetun shadowsocks server for whatever reason.


[ProtonVPN](https://github.com/qdm12/gluetun-wiki/blob/main/setup/providers/protonvpn.md) example using a [custom wireguard](https://github.com/qdm12/gluetun-wiki/blob/main/setup/providers/custom.md#wireguard) provider:

```bash
docker run -it --rm --cap-add=NET_ADMIN \
    -e TZ=Etc/UTC \
    -e VPN_SERVICE_PROVIDER=custom \
    -e VPN_TYPE=wireguard \
    -e VPN_ENDPOINT_IP=1.2.3.4 \
    -e VPN_ENDPOINT_PORT=51820 \
    -e WIREGUARD_PUBLIC_KEY="wAUaJMhAq3NFutLHIdF8AN0B5WG8RndfQKLPTEDHal0=" \
    -e WIREGUARD_PRIVATE_KEY="wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=" \
    -e WIREGUARD_PRESHARED_KEY="xOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=" \
    -e WIREGUARD_ADDRESSES="10.64.222.21/32" \
    -p 8888:8888/tcp \
    -p 8888:8888/udp \
    ghcr.io/marvinpinto/vpn:latest
```

Another example [here](https://github.com/marvinpinto/kitchensink/blob/main/dotfiles/dot_bash.d/vpn.tmpl) of bringing up & tearing down vpn tunnels using bash functions.
