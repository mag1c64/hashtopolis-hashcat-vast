FROM nvidia/cuda:10.0-devel-ubuntu18.04

RUN apt update && apt install -y --no-install-recommends \
  zip \
  git \
  wget \
  python3 \
  python3-psutil \
  python3-requests \
  pciutils \
  curl && \
  rm -rf /var/lib/apt/lists/*

CMD mkdir /root/htpclient

WORKDIR /root/htpclient

RUN wget https://github.com/MilzoCSP/hashtopolis-hashcat-vast/raw/master/hashtopolis.zip
