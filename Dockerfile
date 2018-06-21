FROM debian:stretch-slim

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV BITCOIN_VERSION 0.14.2
ENV BITCOIN_URL https://download.litecoin.org/litecoin-0.14.2/linux/litecoin-0.14.2-x86_64-linux-gnu.tar.gz
ENV BITCOIN_SHA256 05f409ee57ce83124f2463a3277dc8d46fca18637052d1021130e4deaca07b3c
ENV BITCOIN_ASC_URL https://download.litecoin.org/litecoin-0.14.2/linux/litecoin-0.14.2-linux-signatures.asc
ENV BITCOIN_PGP_KEY FE3348877809386C

# install bitcoin binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO bitcoin.tar.gz "$BITCOIN_URL" \
	&& echo "$BITCOIN_SHA256 bitcoin.tar.gz" | sha256sum -c - \
	&& gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$BITCOIN_PGP_KEY" \
	&& wget -qO bitcoin.asc "$BITCOIN_ASC_URL" \
	&& gpg --verify bitcoin.asc \
	&& tar -xzvf bitcoin.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt* \
	&& rm -rf /tmp/*


EXPOSE 9332 9333 19335 19332 19444 19332
VOLUME /root/.litecoin

ENTRYPOINT ["/usr/local/bin/litecoind"]
