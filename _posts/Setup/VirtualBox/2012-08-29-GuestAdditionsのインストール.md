---
categories:
  - Setup
tags:
  - Setup
  - 環境構築
---

# VirtualBox

## Guest Additionsのインストール

1. メニューの[デバイス]から[Guest Additionsのインストール]を選択。
2. CD-ROMとして読み込まれるのでディレクトリにマウントする。

  ```console
  [root@dev ~]# mkdir /mnt/cdrom
  [root@dev ~]# mount -r /dev/cdrom /mnt/cdrom
  ```

3. マウントしたらVBoxLinuxAdditions-x86.runを実行する。
4. gcc、make、kernel-devel辺りが必要なので、入っていなければ入れておく。

  ```console
  [root@dev ~]# yum install gcc make kernel-devel
  [root@dev ~]# /mnt/cdrom/VBoxLinuxAdditions-x86.run]
  ```

5. インストールが終ったらCD-ROMをアンマウントしておく。

  ```console
  [root@dev ~]# umount /mnt/cdrom
  ```
