FROM ubuntu:22.04

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y git wget xz-utils python3 autoconf gcc make

RUN mkdir /tools
WORKDIR /tools

RUN wget https://ftp.gnu.org/gnu/automake/automake-1.15.tar.gz
RUN tar xf automake-1.15.tar.gz
WORKDIR ./automake-1.15
RUN ./configure
RUN make
RUN make install

WORKDIR /
