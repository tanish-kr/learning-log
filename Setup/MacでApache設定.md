# MacでApache設定

## GUIで起動

システム環境設定→共有→Web共有　で起動できる

## コマンド

```bash
$ sudo /usr/sbin/apachectl start
```

## apacheの構文テスト

```console
# httpd -t
# apachectl configtest
```

## パーソナルウェブサイト
localhost/~username

## ヴァーチャルホスト

### /etc/apache2/httpd.conf

```apache
 Include /private/etc/apache2/extra/httpd-vhosts.conf
```


### /etc/apache2/extra/httpd-vhosts.conf

```apache
<VirtualHost *:80>
  ServerAdmin webmaster@php_application_demo.com
  DocumentRoot "/Users/username/WorkSpace/PHP/"
  ServerName php_application_demo.com
  ErrorLog "/private/var/log/apache2/php_application_demo.com-error_log"
  CustomLog "/private/var/log/apache2/php_application_demo-access_log" common
  <Directory "/Users/username/WorkSpace/PHP/">
      Options Indexes FollowSymLinks MultiViews
      #AllowOverride AuthConfig
      Order deny,allow
      Allow from All
  </Directory>
</VirtualHost>
```

###  /etc/hosts

```ini
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
fe80::1%lo0     localhost
127.0.0.1       php_application_demo.com
```
