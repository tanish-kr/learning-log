---
categories:
  - Infrastructure
  - Docker
tags:
  - Docker
---

# Docker sample

## Webサーバ(nginx)をDockerで起動する

### Dockerfile

```docker
FROM debian:stable-slim

# Install requirements
RUN apt update && \
    apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring

# nginx署名keyのインポート
RUN curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# aptリポジトリの設定
RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

RUN apt update && apt install -y nginx

CMD service nginx start
```

### Image作成

```
$ docker build . -t nginx:sample
$ docker ps
REPOSITORY                                      TAG                   IMAGE ID       CREATED              SIZE
nginx                                           sample                b39ee66c9b85   About a minute ago   143MB

```


