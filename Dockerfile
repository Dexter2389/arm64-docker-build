# Fetch latest changes from Github
FROM alpine/git:latest as repo
RUN git clone -b main --depth 1 https://github.com/mattermost/focalboard.git /focalboard

# Build webapp
FROM node:16.3.0-alpine as nodebuild
RUN apk --no-cache add pkgconfig autoconf automake libtool nasm build-base zlib-dev libpng-dev
WORKDIR /webapp
COPY --from=repo /focalboard/webapp /webapp
RUN export CFLAGS="$CFLAGS -DPNG_ARM_NEON_OPT=0" && npm --verbose install --no-optional && npm run pack

# Build Go backend
FROM golang:1.17.5-alpine as gobuild
RUN apk add --no-cache make build-base
WORKDIR /go/src/focalboard
COPY --from=repo /focalboard /go/src/focalboard
RUN sed -i "s/GOARCH=amd64/GOARCH=arm64/g" Makefile
RUN make server-linux
RUN mkdir /data

# Build Final image
FROM alpine

WORKDIR /opt/focalboard

COPY --from=gobuild --chown=1000:1000 /data /data
COPY --from=nodebuild --chown=1000:1000 /webapp/pack pack/
COPY --from=gobuild --chown=1000:1000 /go/src/focalboard/bin/linux/focalboard-server bin/
COPY --from=gobuild --chown=1000:1000 /go/src/focalboard/LICENSE.txt LICENSE.txt
COPY --from=gobuild --chown=1000:1000 /go/src/focalboard/docker/server_config.json config.json

EXPOSE 8000/tcp

EXPOSE 8000/tcp 9092/tcp

VOLUME /data

ENTRYPOINT ["/opt/focalboard/bin/focalboard-server"]