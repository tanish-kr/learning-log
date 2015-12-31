## BINDのインストール

```console
# yum -y install bind bind-chroot bind-libs
```

[chrootとは](http://www.atmarkit.co.jp/flinux/rensai/bind909/bind909a.html)

## namedサービス

|Service Name|named|
|------------|-----|
|Protocol and port|53/TCP 53/UDP|
|SELinux Module|bind 1.10.2|
|Daemon Program|/usr/sbin/named/|
|Configuration files|/etc/sysconfig/named, /etc/named.conf or /var/named/chroot/etc/named.conf|
|Document files |/usr/share/doc/bind-9.7.0|
|Pid file|/var/named/named.pid or /var/named/chroot/var/run/named/named.pid|
|Lock file|/var/lock/shbsys/named|
|Control script|/etc/init.d/named|
|Script parameters|start stop status restart reload condrestart try-restart|
|Startup| 2 3 4 5/ 13 87|

## 必要ファイルのコピー

- 設定ファイル・ゾーンファイル

      /var/named/chroot/etc
      named.conf
      named.xxx.zone

```console
 #cp etc/* /var/named/chroot/etc/
```

## named.conf編集


```
options //環境設定
{
  directory "/var/named"; //ZONEファイルとDNS探索rootファイルが設置されている場所を指定。
  dump-file "data/cache_dump.db"; //キャッシュの保管場所
  statistics-file "data/named_stats.txt";名前解決の回数などの統計データを保存するファイル
  memstatistics-file "data/named_mem_stats.txt";サーバ終了時にメモリ使用統計について出力するファイルのパス名
};

allow-query {localhost;}; //アクセス許可ホスト
allow-query-chache {localhost;};
view "internal" {//内部向けDNSの設定
match-clients { 192.168.11.0/24; };
match-destinations { 192.168.11.0/24; };

zone "." IN { //DNSのルート探索
  type hint;
  file "/var/named/named.ca";
};

acl "localnet" { //アクセスコントロールの対象を定義
  192.168.x.x/24; //LAN側のアドレス
  127.0.0.1; //サーバ自身(localhost)
};

zone "0.0.127.in-addr.arpa"{ //localhost逆引き
  type master;
  file "named.0.0.127.in-addr.arpa";
};

zone "testhog.net" { //自ドメイン正引き
  type master;
  file "test.hoge.local";
  allow-transfer {localnet;};
};

# 外部向けDNSの設定
view "external"
{
  match-clients { any; };
  match-destinations { any; };
  recursion no;
  allow-query-cache { none; };
  include "/etc/named.root.hints";
  include "/etc/named.rfc1912.zones";

  zone "oss-d.net" {
  type master;
  file "oss-d.net.ex_zone";
};

};
};
```

### 文法チェック

```console
# /usr/sbin/named-checkconf
```

### ゾーンファイル作成

#### 内部向けゾーン

- 正引きゾーン

```console
[root@centos ~]# vi /var/named/chroot/var/named/centossrv.com.db　←　正引きゾーンデータベース作成
```

```sh
@ IN SOA centossrv.com. root.centossrv.com.(

                                    2005120201 ; Serial
                                    28800      ; Refresh
                                    14400      ; Retry
                                    3600000    ; Expire
                                    86400 )    ; Minimum
      IN NS    centossrv.com.
      IN MX 10 mail.centossrv.com.

@ IN A 192.168.1.2
www IN A 192.168.1.2
ftp IN A 192.168.1.2
mail IN A 192.168.1.2
```

- 逆引きゾーン

```console
[root@centos ~]# vi /var/named/chroot/var/named/1.168.192.in-addr.arpa.db　←　逆引きゾーンデータベース作成
```

```sh
$TTL 86400
@ IN SOA centossrv.com. root.centossrv.com.(

                                    2004031901 ; Serial
                                    28800      ; Refresh
                                    14400      ; Retry
                                    3600000    ; Expire
                                    86400 )    ; Minimum
            IN      NS    centossrv.com.

2 IN PTR centossrv.com.　←　サーバーIPアドレス最下位部(192.168.1.2)とドメイン名を指定
```

## DNSの確認

bind-utilsインストール

```console
# yum -y install bind-utils
```

### hostコマンド

```console
$ host www.hoge.jp
```

### digコマンド

```console
$ dig www.hoge.jp
```
