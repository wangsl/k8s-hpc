FROM ubuntu:24.04

RUN apt-get -y update && \
  apt-get install -y gcc g++ automake make wget git && \
  apt-get install -y squashfs-tools cmake cmake-curses-gui net-tools strace lsof zip unzip openssh-server subversion gdb && \
  apt-get -y install build-essential git emacs wget curl libjpeg62 vim nano  rsync && \
  apt-get -y install gfortran flex bison  openmpi-bin squashfuse libopenmpi-dev
