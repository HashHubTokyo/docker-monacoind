FROM ubuntu:16.04

RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:bitcoin/bitcoin && \
    apt update && \
    apt install -y bitcoind && \
    apt upgrade -y && \
    apt autoremove -y

EXPOSE 8332 8333 18332 18333
VOLUME /root/.bitcoin

ENTRYPOINT [ "/usr/bin/bitcoind" ]
