# Focalboard ARM64 Docker build

[![Focalboard ARM64 Build](https://github.com/Dexter2389/arm64-docker-build/actions/workflows/focalboard-build.yml/badge.svg)](https://github.com/Dexter2389/arm64-docker-build/actions/workflows/focalboard-build.yml)

[Focalboard](https://www.focalboard.com) is an open source, self-hosted project management tool that's an alternative to Trello, Notion, and Asana.

I wanted to setup Focalboard on my RaspberryPi 4, but since they don't have an offical image for `linux/ARM64` version, I decided to build one for it. I will try to keep up with their offical releases.

## Usage

- Create a `config.json` file with the following properties.

```json
{
    "serverRoot": "http://localhost:8000",
    "port": 8000,
    "dbtype": "sqlite3",
    "dbconfig": "/data/focalboard.db",
    "postgres_dbconfig": "dbname=focalboard sslmode=disable",
    "useSSL": false,
    "webpath": "./pack",
    "filespath": "/data/files",
    "telemetry": true,
    "session_expire_time": 2592000,
    "session_refresh_time": 18000,
    "localOnly": false,
    "enableLocalMode": true,
    "localModeSocketLocation": "/var/tmp/focalboard_local.socket"
  }
```

- Create a folder called `data` (this is the folder in which we will bind with to our docker image).

- Create a `docker-compose.yml` file with the following properties.

```yaml
version: "3"
services:
    focalboard:
        image: dexter2389/focalboard:latest
        container_name: focalboard
        ports:
            - 9889:8000
        volumes:
            - ./data:/data
            - ./config.json:/opt/focalboard/config.json
        restart: unless-stopped

```
