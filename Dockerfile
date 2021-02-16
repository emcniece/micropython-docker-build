# trusty: 14.04
# bionic: 18.04
# focal: 20.04
#FROM ubuntu:trusty # 499MB
#FROM ubuntu:bionic # 536MB
FROM ubuntu:focal

ENV MPY_BRANCH=master
ENV MPY_PORT_ARCH=esp8266
ENV PATH=/esp-open-sdk/xtensa-lx106-elf/bin:$PATH

# ubuntu:trustu
# RUN apt-get update \
#  && DEBIAN_FRONTEND=noninteractive apt-get install -y make autoconf automake libtool gcc g++ gperf \
#     flex bison texinfo gawk ncurses-dev libexpat-dev python-dev python python-serial \
#     sed git unzip bash help2man wget bzip2 \
#  && apt-get clean \
#  && rm -rf /var/lib/apt/lists/*

# ubuntu:focal
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y make autoconf automake libtool gcc g++ gperf \
    flex bison texinfo gawk ncurses-dev libexpat-dev python-dev python \
    sed git unzip bash help2man wget bzip2 libtool-bin \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*



RUN git clone https://github.com/pfalcon/esp-open-sdk.git --recursive --depth=1 \
 && git clone https://github.com/micropython/micropython.git --branch $MPY_BRANCH --depth=1 \
 && rm -rf /esp-open-sdk/crosstool-NG \
 && git clone https://github.com/crosstool-ng/crosstool-ng /esp-open-sdk/crosstool-NG --depth=1

ADD ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD cd "/micropython/ports/$MPY_PORT_ARCH" && build
