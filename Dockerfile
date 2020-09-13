# Build and run KDE marble with North America vector files available offline.

# Build stage
# Use Ubuntu vs. Alpine as KDE Marble is designed for Ubuntu
FROM ubuntu:focal-20200729
LABEL maintainer="Ying Wang"
LABEL application="marble"

# Set build arguments.
ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get install -y build-essential
RUN apt-get install -y qtcreator
RUN apt-get install -y qt5-default
RUN apt-get install -y git
RUN apt-get install -y cmake
RUN apt-get install -y make
RUN apt-get install -y libqt5svg5-dev
RUN apt-get install -y qtdeclarative5-dev

RUN mkdir -p /root/marble/sources
RUN git clone \
    -b v20.04.3 \
    https://invent.kde.org/education/marble \
    /root/marble/sources

# NOTE: Must be within source directory when compiling, otherwise will result in
# error.
#
# See: https://gitlab.kitware.com/cmake/cmake/issues/17940
WORKDIR /root/marble/sources

RUN cmake \
    -DCMAKE_BUILD_TYPE=Debug \
    -DWITH_KF5=TRUE \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    .

# NOTE: I have 12 CPU cores on my Xeon
RUN /usr/bin/make -j12

RUN /usr/bin/make install

RUN ln -s /usr/local/bin/marble-qt /usr/local/bin/marble

# RUN apt-get install -y xorg
# RUN apt-get install -y openbox
# RUN apt-get install -y lightdm

# Run commands.
CMD [ "exec", "\"@\"" ]
