# Build stage

FROM alpine:3.11.5 AS build

LABEL application=marble

# Release stage
FROM alpine:3.11.5

LABEL application=marble

ENTRYPOINT [ "/app/entrypoint.sh" ]
