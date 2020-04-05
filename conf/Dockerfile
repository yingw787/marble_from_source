# Build and run KDE marble with North America vector files available offline.

# Build stage
FROM alpine:3.11.5 AS build
LABEL application=marble

RUN apk add cmake
RUN apk add gcc
RUN apk add g++
RUN apk add git
RUN apk add make
RUN apk add qt5-qtquickcontrols2-dev
RUN apk add qt5-qttools-dev
RUN apk add qt5-qtsvg-dev
RUN apk add qt5-qtwebkit-dev

RUN git clone \
    -b Applications/17.04 \
    git://anongit.kde.org/marble \
    /root/marble/sources

# Release stage
FROM alpine:3.11.5
LABEL application=marble

ENTRYPOINT [ "/app/entrypoint.sh" ]
