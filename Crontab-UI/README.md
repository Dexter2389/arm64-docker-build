# Crontab-UI ARM64 Docker build

[![Crontab-UI ARM64 Build](https://github.com/Dexter2389/arm64-docker-build/actions/workflows/crontab-ui-build.yml/badge.svg)](https://github.com/Dexter2389/arm64-docker-build/actions/workflows/crontab-ui-build.yml)

[Crontab-UI](https://github.com/alseambusher/crontab-ui) is an easy and safe way to manage your crontab file.

I wanted to setup Crontab-UI on my RaspberryPi 4, but since they don't have an offical image for `linux/ARM64` version, I decided to build one for it. I will try to keep up with their offical releases.

## Usage

- Create a `docker-compose.yml` file with the following properties.

```yaml
version: "3"
services:
    crontab-ui:
        image: dexter2389/crontab-ui:latest
        container_name: crontab-ui
        ports:
            - 9879:8000
        restart: unless-stopped

```
