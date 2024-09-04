FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive

LABEL maintainer="Alexander Alemayhu"

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo git vim make ruby curl nodejs npm && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -pv /tmp/
ADD . /tmp/config-files
WORKDIR /tmp/config-files

RUN make all
