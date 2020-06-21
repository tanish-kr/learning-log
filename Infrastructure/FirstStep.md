# FirstSetp

## 1.導入前に検討する事

### ①使用目的に応じたパッケージ選び

    サーバ用途、デスクトップ用途etc

### ②必要なディスク容量の見積もりとディスク分割の方針の決定

    - データ更新の多いディレクトリは独立パーティション、あるいは独立ユニットにする
    - 静的なファイルが多いディレクトリは同じパーティションに固める
    - ブート情報がおかれているディレクトリ(/boot)は別パーティションにすることを検討する

- 更新頻度の低いディレクトリ
>/bin,/boot,/etc,/lib,/sbin,/usr/xxx(/usr/local以外の静的なディレクトリ)

- 逐次使われるディレクトリ
>/dev,/tmp

- ディスクの読み書きが激しいディレクトリ
>/var,/home,その他、独自で設けたコンテンツディレクトリなど

- 主に読み書きが頻繁に発生するディレクトリ
>/opt,/usr/xxx(ライブラリやアプリケーションがインストールされているディレクトリ),その他、独自で設けたアプリケーションディレクトリなど

### ③ネットワーク情報

 - ホスト名
 - IPアドレスとネットマスク
 - ブロードキャストアドレス
 - デフォルトゲートウェイのIPアドレス
 - ドメインネームサーバのIPアドレス
 - そのほかのルーティングルール

### ④デバイス情報

## 2. Linuxの起動シーケンス

    ①BIOS起動、デバイス認識・初期化
    ②起動ディスクのMBRをロードし、制御を渡す
    ③ブートローダ(LILO,GRUBなど)が起動
    ④選択メニューにより該当パーティションからカーネルイメージをロードする
    ⑤デバイスの初期化,モジュールのロード、rootファイルシステムのロードを行う
    ⑥initプログラムを実行し、初期化スクリプトを実行する
    ⑦ランレベルに合わせたrcスクリプトを実行する

### initとinittab
pstreeコマンドを実行すると、すべてのプロセスがinitから生み出されている事が分かります

### /etc/inittabの書式

    ランレベル
    0:停止
    1:シングルユーザモード
    2:NFSを使用しないテキストモード(マルチユーザモード)
    3:テキストモード(マルチユーザモード)
    4:自由に使ってかまわない(決まっていない)
    5:GUIログインモード(マルチユーザモード)
    6:再起動

- /etc/inittabnの基本書式
>id:runlevel:action:process

- id:エントリの識別子ユニークな文字列1〜4文字
- runlevel:ランレベルの指定。1〜6までの数字
- action:プロセスの起動、または終了時の動作
- process:実行されるプロセスを指定します

### rc.sysinit

カーネルを読み込んだ後に実行される。

- ネットワークの初期化
- SELinuxの設定
- コンソールタイプの設定
- rcスクリプトで呼び出すルーチンの定義
- Welcomeバナーの表示
- /procファイルシステムのマウント
- カーネルパラメータの設定
- クロックの設定
- keymapの読み込み
- ホストネームの設定
- 電源管理ACPIの設定
- USBの初期化
- 必要に応じてfsckの実行
- quotaのチェック
- 必要に応じてinitrdをumount
- quotaの更新
- isapnpの設定
- rootファイルシステムのマウント
- LVMの設定
- スワップの設定
- カーネルモジュールの読み込み
- ハードディスクパラメータの設定
- フラグファイルのクリア

### rcスクリプト

サーバの起動や停止など、システム起動後に変更したい部分の設定を行います

## スーパーサーバinetdの仕組み

    サーバを起動するサーバ
    スーパー・サーバ・デーモン
    ポートへのアクセスを常時監視して、必要に応じてサーバデーモンを起動するプログラムです。
    アクセス頻度が低いサービスの起動に適している

### /etc/inetd.confの設定

    ①サービス名
    ②終端タイプ
      TCP->stream,UDP->dgram
    ③プロトコル
    ④待ちステータスフラグ(streamの場合自動的にnowaitとなる)
    ⑤ユーザ名
    ⑥サーバプログラム
    ⑦サーバアーギュメント

### サービスの再起動と停止

- /var/run/inetd.pidがある場合

```console
# kill -HUP `cat /var/run/inetd.pid`
```
- 無い場合

```console
# kill -HUP 552
```

### 追記

#### vim
vimを入れときます

```console
# yum install -y vim-enhanced
```

#### 画面解像度

```console
/etc/groub.conf
kernel/ ...vga=773
http://linux.kororo.jp/cont/tips/console_vga.php
```

##### 特定ユーザにroot操作権限付与

```console
# visudo
# sudoers file.
#
# This file MUST be edited with the 'visudo' command as root.
#
# See the sudoers man page for the details on how to write a sudoers file.
#

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL) ALL
nori    ALL=(ALL) ALL　# ←この行を追加
```
