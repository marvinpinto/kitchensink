# DNS Proxy Container

The primary usecase is to be able to tunnel Firefox container DNS traffic through specific servers, without needing to manually change your (firefox) DNS-over-TLS settings, or your machine's DNS settings.

In an environment where DNS requests are filtered or blocked (i.e. Adguard), it is useful to have a way to "turn it off" for specific websites. Pair this SOCKS5 proxy with Firefox Multi-Account Containers and you have a dynamic way of tunneling your DNS requests.

```bash
docker run -it --rm \
    -e TZ=Etc/UTC \
    -e DNS_SERVERS="8.8.8.8,8.8.4.4" \
    -p 8888:8888/tcp \
    -p 8888:8888/udp \
    ghcr.io/marvinpinto/dnsproxy:latest
```

Another example [here](https://github.com/marvinpinto/kitchensink/blob/main/dotfiles/dot_bash.d/vpn.tmpl) of bringing up & tearing down dnsproxy tunnels using bash functions.
