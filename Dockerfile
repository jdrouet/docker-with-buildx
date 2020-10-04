ARG BUILDX_VERSION=0.4.2
ARG DOCKER_VERSION=latest

FROM alpine AS fetcher

RUN apk add curl

ARG BUILDX_VERSION
RUN curl -L \
  --output /docker-buildx \
  "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-amd64"

RUN chmod a+x /docker-buildx

ARG DOCKER_VERSION
FROM docker:${DOCKER_VERSION}

COPY --from=fetcher /docker-buildx /usr/lib/docker/cli-plugins/docker-buildx
