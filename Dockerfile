FROM debian:10-slim

RUN apt-get update
RUN apt-get install -y git automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev zlib1g-dev make g++
RUN git clone https://github.com/tpruvot/cpuminer-multi.git
WORKDIR cpuminer-multi
RUN ./autogen.sh
RUN ./configure --prefix=/opt/cpuminer-multi --with-crypto --with-curl
RUN make
RUN make install

FROM debian:10-slim

COPY --from=0 /opt/ /opt/
RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev zlib1g-dev && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/opt/cpuminer-multi/bin/cpuminer" ]
CMD [ "--help" ]
