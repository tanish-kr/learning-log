# SSHサーバ構築

## sshdサービス

|Service Name|sshd|
|------------|----|
|port|22/TCP|
|Deamon Program|/usr/sbin/sshd|
|Configuration files|/etc/ssh/sshd|
|Pid file|/var/run/sshd.pid|
|Lock file|/var/lock/subsys/sshd|
|Control script|/etc/init.d/sshd|
|Script parameters|start stpo restart reload conderestart status|
|Startup|2 3 4 5/ 55 25|

## OpenSSHのインストール

- openssh-serverのインストール

```console
# yum -y install openssh-server
```

- openssh-clientsのインストール

```console
# yum -y install openssh-clients
```

## 設定

### /etc/ssh/sshd_config

```sshd_config
#ListenAddress 0.0.0.0  ←接続許可IPを指定
#Authentication:
#LginGraceTime
PermitRootLogin yes #->noに変更(root(管理者)でのログインを禁止)
RhostsAuthentication no　# ←パスワードなしでログインできるrhosts認証を禁止
RSAAuthentication yes　　 # ←RSA鍵ファイルを利用したユーザー認証を許可
RhostsRSAAuthentication yes　# ←RSA鍵の交換でrhosts認証を許可
PasswordAuthentication yes # ->通常パスワード認証
PermitEmptyPasswords no　　# ←パスワードなしでのログインを禁止
AllowUsers user　　# ←SSHでログインできるユーザーを限定(例：ユーザー名が"user"の場合)
#SyslogFacility AUTH ←ログを出力するファリリティの指定
SyslogFacility AUTHPRIV > /var/log/secure　 # ログ記録先
#LogLevel INFO ログ出力レベルの設定
```

### 再起動

```console
# /etc/rc.d/init.d/sshd restart
```

### 鍵の作成

```console
[user@ssh]$ ssh-keygen -t rsa
Generating public/private rsa key pair.
>何も入力しないでエンターキー押下
Enter file in which to save the key (/home/linux/.ssh/id_rsa):
Created directory '/home/linux/.ssh'.
パスフレーズ(SSH2のパスワード)入力
Enter passphrase (empty for no passphrase):
パスフレーズの再入力(上記で入力したもの)
Enter same passphrase again:
Your identification has been saved in /home/linux/.ssh/id_rsa.
Your public key has been saved in /home/linux/.ssh/id_rsa.pub.
The key fingerprint is:
cc:f6:fe:9b:51:f1:68:fa:61:b4:76:cb:e4:35:99:b8 user@localhost.com
```

SSHv2,SSHv1と2つのバージョンがある。SSHv1を使用する場合、

```console
$ ssh-keygen -t rsa1
```

windowsのTTSSHはSSHv1のみをサポートしている
現在非推奨

### 鍵の作成先の表示

```console
[linux@fedora linux]$ ls -la /home/linux/.ssh/
合計 16
drwx------  2 linux linux 4096  9・27 14:09 .
drwx------  3 linux linux 4096  9・27 14:09 ..
-rw-------  1 linux linux  951  9・27 14:09 id_rsa      ← 秘密鍵
-rw-r--r--  1 linux linux  238  9・27 14:09 id_rsa.pub  ← 公開鍵
# 公開鍵をauthorized_keysに追加
[linux@fedora linux]$ cat /home/linux/.ssh/id_rsa.pub >> /home/linux/.ssh/authorized_keys
# 公開鍵を自分のみアクセスできるように変更
[linux@fedora linux]$ chmod 600 /home/linux/.ssh/authorized_keys
# 公開鍵の削除
[linux@fedora linux]$ rm -f /home/linux/.ssh/id_rsa.pub
```

### 鍵を配布(mac)

### virtualbox設定

### ネットワーク設定

- eth1追加

```sh
/etc/sysconfig/network-scripts/eth1
DEVICE="eth1"
BOOTPROTO="static"
IPADDR=192.168.xx.xx
NETMASK=255.255.255.0
ONBOOT="yes"
```

### 接続

mac

```console
$ ssh -l (loginuser) (hostname) -i (key)
```
