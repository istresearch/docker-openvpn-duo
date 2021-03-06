# Original credit: https://github.com/kylemanna/docker-openvpn

# Smallest base image
FROM alpine:3.4

MAINTAINER Gary Windham <windhamg@gmail.com>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    apk add --update alpine-sdk python && \
    curl -L https://github.com/duosecurity/duo_openvpn/tarball/master > /tmp/duo-openvpn.tgz && \
    cd /tmp && tar xvzf duo-openvpn.tgz && cd duosecurity-duo_openvpn* && make install && cd / && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
