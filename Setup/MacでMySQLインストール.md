## MacPortを使用しインストール

```console
$sudo port install mysql5-devel mysql5-server-devel
```

## mysql初期設定
ここでハマった…

```sonsole
$ sudo -u mysql mysql_install_db5
```

成功していれば以下のようになる

```console
$mysqlshow
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| test               |
+--------------------+
```

だが…

```console
$mysqlshow
+--------------------+
| Database           |
+--------------------+
| information_schema |
| test               |
+--------------------+
```

mysqlテーブル作成されてないorz

pkgを普通にダウンロードしてからdmgからインストールすると
なぜか初期設定がうまくいかない現象に悩まされた  
なのでMacportからインストールすることにした

ちなみにdmgからインストールしたものを削除しなけらばならない

```console
$ sudo rm -rf /usr/local/mysql
$ sudo rm -rf /usr/local/mysql-5.5.20-osx10.6-x86_64/
$ sudo rm -rf /etc/my.cnf
$ sudo rm -rf /Library/StartupItems/MySQLCOM/
```

### パッケージ関連の情報も削除

```console
$ sudo pkgutil --unlink com.mysql.mysql
$ pkgeutil --forget com.mysql.mysql
$ sudo pkgutil --unlink com.mysql.mysqlstartup
$ sudo pkgutil --forget com.mysql.mysqlstartup
```

## mysql起動

```console
$ sudo /opt/local/share/mysql5/mysql/mysql.server start
```

## rootパスワード設定

```console
$ /opt/local/lib/mysql5/bin/mysqladmin -u root password 'password'
```

## mysqlに接続

```console
$ mysql5 -u root -p
```

## ユーザの確認

```console
SELECT Host, User, Password FROM mysql.user;
+----------------------------+------+-------------------------------------------+
| Host                       | User | Password                                  |
+----------------------------+------+-------------------------------------------+
| localhost                  | root | ###### |
| MacBookAir | root |                                           |
| 127.0.0.1                  | root |                                           |
| localhost                  |      |                                           |
|  |      |                                           |
+----------------------------+------+-------------------------------------------+
```

## データベース一覧

```console
SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| test               |
+--------------------+
```

## 自動起動設定

```console
$ sudo launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist
 ```

この辺参考
http://akio0911.net/archives/2548
http://d.hatena.ne.jp/ihiro81/20110809/1312872339
