---
categories:
  - Infrastructure
  - Docker
tags:
  - Docker
---

# Docker Compose

複数のコンテナを定義し実行するツール。YAMLで定義(`docker-compose.yml`)した内容に基づいてDockerコンテナを構築する

## Composeコマンド

### up

Composeで定義したすべてのコンテナを起動し、出力されるログを集約する。`-d`オプションでバックグラウンドで実行可能

### build

Dockerfiles群から生成されるイメージを再構築する。upコマンドは、イメージが存在しない場合を除けばイメージの構築は行わないので、イメージを更新する必要がある場合、このコマンドを使用する

### ps

Composeが管理しているコンテナの状態を表示する

### run

単発のコマンドを実行するためにコンテナを起動する

### logs

Composeが管理しているコンテナのログを出力する

### stop

起動しているコンテナを停止する

### rm

停止しているコンテナを削除する。ボリュームを削除する場合は`-v`オプションを指定する必要がある

## Composeファイル

### version

Composeのバージョン。必須

- [バージョン一覧](https://docs.docker.com/compose/compose-file/)

### services

サービス定義には、そのサービスで開始されたコンテナに適用される構成を記述する

#### build

build対象(Dockerfile)へのパスを指定



