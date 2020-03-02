FROM ubuntu:18.04

# Configure process-wide environment variables.
# Eliminate interactivity warnings from `apt` and other Debian-based tooling.
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade

ENTRYPOINT [ "/app/entrypoint.sh" ]
