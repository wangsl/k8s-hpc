
FROM ubuntu:22.04

ENV TZ "America/New_York"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y tzdata build-essential gfortran automake make wget git file \
    python3 rsync openssh-client net-tools bc expect \
    cmake cmake-curses-gui \
    libblas-dev liblapack-dev libpcre3-dev libarpack2-dev libcurl4-gnutls-dev epstool libfftw3-dev libhdf5-dev libboost-all-dev
