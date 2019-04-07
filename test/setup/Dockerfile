FROM debian:stretch

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && \
  apt-get install --yes git

RUN apt-get install --yes wget

RUN git clone https://github.com/bats-core/bats-core.git && \
  cd bats-core && \
  git checkout v1.1.0 && \
  ./install.sh /usr/local && \
  cd .. && \
  rm -rf bats-core

ENV PATH=/root/.local/bin:/opt/sdd/bin:$PATH

ENTRYPOINT /bin/bash
