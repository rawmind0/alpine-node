[![](https://images.microbadger.com/badges/image/rawmind/alpine-node.svg)](https://microbadger.com/images/rawmind/alpine-node "Get your own image badge on microbadger.com")

alpine-node
=============

This image is the node base. It comes from rawmind/alpine-monit.

## Build

```
docker build -t rawmind/alpine-node:<version> .
```

## Versions

- `10.1.0-1` [(Dockerfile)](https://github.com/rawmind0/alpine-node/blob/10.1.0-1/Dockerfile)
- `9.11.1-0` [(Dockerfile)](https://github.com/rawmind0/alpine-node/blob/9.11.1-0/Dockerfile)
- `8.11.2-1` [(Dockerfile)](https://github.com/rawmind0/alpine-node/blob/8.11.2-1/Dockerfile)
- `6.9.5` [(Dockerfile)](https://github.com/rawmind0/alpine-node/blob/6.9.5/Dockerfile)
- `6.7.0` [(Dockerfile)](https://github.com/rawmind0/alpine-node/blob/6.7.0/Dockerfile)
- `5.12.0` [(Dockerfile)](https://github.com/rawmind0/alpine-node/blob/5.12.0/Dockerfile)


## Usage

To use this image include `FROM rawmind/alpine-node` at the top of your `Dockerfile`. Starting from `rawmind/alpine-monit` provides you with the ability to easily start any service using monit. monit will also keep it running for you, restarting it when it crashes.

To start your service using monit:

- create a monit conf file in `/opt/monit/etc/conf.d`
- create a service script that allow start, stop and restart function
