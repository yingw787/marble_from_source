FROM ubuntu:18.04

# Configure process-wide environment variables.
# Eliminate interactivity warnings from `apt` and other Debian-based tooling.
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade

# Download source code for KDE Marble, and build the environment from source.

# Download 'north-america-latest.osm.pbf'. Note that this step is expensive and
# should be cached.

# Convert '*.osm.pbf' into vector tiles via `marble-vectorosm-tilecreator`.

ENTRYPOINT [ "/app/entrypoint.sh" ]
