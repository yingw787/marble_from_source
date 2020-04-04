# `marble_from_source`: Building KDE Marble from source, in order to build tools to convert osm.pbf files into map tiles

## Overview

I wanted to have a set of offline maps for a long walk I might want to do, where
I might not have Internet access (or where map data would be extremely expensive
to fetch).

I took a look online and apparently desktop Linux has [KDE
Marble](https://marble.kde.org/), an offline-first mapping tool, with the
ability to take in OpenStreetMap `*.osm.pbf` dumps. However, the tool to convert
.pbf files into Marble-based vector tiles only exists if you build KDE Marble
from source. After running into some issues building it locally, I decided to
Dockerize the process using my [handy dandy dev
workflow](https://bytes.yingw787.com/posts/2020/02/27/docker_as_vagrant/).

## Notes

-   https://github.com has a file size limit of 2GB, with a repository limit of
    100GB. `north-america-latest.osm.pbf`, the weekly data dump of North
    American OpenStreetMap data provided via mirror, is around 9GB. There are no
    data chunking tools available either via OpenStreetMap, or via `git-lfs`,
    that I have seen. Therefore, I'm adding Docker `RUN` commands to download
    the `.osm.pbf` file as part of the `docker build` runtime step in lieu of
    checking in a data dump into version control. I'm too cheap in order to sync
    a blob to S3 and pay the $2 / mo. in hosting costs. If I use multi-stage
    builds, I don't even need to store the `.osm.pbf` files, I'll just have the
    final vector tiles that I can scrape from my filesystem using `ncdu`.
