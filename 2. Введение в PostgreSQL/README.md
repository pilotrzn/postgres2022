# Домашнее задание

Стенд для развертывания
* host Debian
* VirtualBox

Установлена ВМ с UBUNTU

$ cat /etc/os-release
```
PRETTY_NAME="Ubuntu 22.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.1 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

## SSH
```$ ssh-keygen -t rsa -b 4096 ```

к виртуалке подключен по отдельному сетевому адресу, наличие ключа пока не принципиально. в двльнейшем будет использоваться между ВМ

## Установка PostgreSQL, 15 версия
```$ sudo apt update && sudo apt upgrade -y 
$ sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' 
$ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - 
$ sudo apt-get update 
$ sudo apt-get -y install postgresql-15
```

## проверка запуска

$ pg_lsclusters
```
Ver Cluster Port Status Owner    Data directory              Log file
15  main    5433 online postgres /var/lib/postgresql/15/main /var/log/postgresql/postgresql-15-main.log
```

листинг pg_hba.conf

$ cat /etc/postgresql/15/main/pg_hba.conf

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             postgres                                peer
local   all             all                                     peer
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             ::1/128                 scram-sha-256
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256
```

## подключение из 2 консолей

![consoles][1]

[1]: img/pg2console.bmp

## создаем БД для тестов
```
postgres=# create database learning;
CREATE DATABASE
```
