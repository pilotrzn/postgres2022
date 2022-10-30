# Домашнее задание

[Стенд для развертывания](#Стенд-для-развертывания)

[SSH](#SSH)

## Стенд для развертывания

* host Debian
* VirtualBox

Установлена ВМ с UBUNTU

$ cat /etc/os-release

```text
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

### SSH

Процедура создания ключа.

```code
ubuntu_srv1:~$ ssh-keygen -t rsa -b 4096
```

К виртуалке подключен по отдельному сетевому адресу, наличие ключа пока не принципиально. В дальнейшем будет использоваться между ВМ. В случае работы с удаленным сервером, например на облаке, актуально использовать ssh шифрование для защищенного доступа.

## Установка PostgreSQL, 15 версия

```$ sudo apt update && sudo apt upgrade -y
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' 
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - 
sudo apt-get update 
sudo apt-get -y install postgresql-15
```

### проверка запуска

$ pg_lsclusters

```text
Ver Cluster Port Status Owner    Data directory              Log file
15  main    5433 online postgres /var/lib/postgresql/15/main /var/log/postgresql/postgresql-15-main.log
```

### листинг pg_hba.conf

$ cat /etc/postgresql/15/main/pg_hba.conf

```text
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             postgres                                peer
local   all             all                                     peer
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             ::1/128                 scram-sha-256
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256
```

### подключение из 2 консолей

![consoles][1]

[1]: img/pg2console.bmp

## Работа с уровнями изоляции

## создаем БД для тестов

```sql
postgres=# create database learning;
CREATE DATABASE
postgres=# /c learning;
Вы подключены к базе данных "learning" как пользователь "postgres".
learning=#
```

### Выключаем autocommit

```sql
learning=# \set AUTOCOMMIT off
```

### Создаем таблицу, наполняем ее данными

```sql
learning=# create table persons(id serial, first_name text, second_name text);
learning=# insert into persons(first_name, second_name) values('ivan', 'ivanov');
learning=# insert into persons(first_name, second_name) values('petr', 'petrov');
learning=# commit;
CREATE TABLE
INSERT 0 1
INSERT 0 1
COMMIT
learning=#
```

### тестируем read committed

```sql
learning=# show transaction isolation level;
 transaction_isolation
-----------------------
 read committed
(1 строка)

learning=#
```

В обеих консолях вводим "BEGIN". В результате получаем отображение "*" строке.

```sql
learning=# begin;
BEGIN
learning=*# 
```

В первой консоли выполняем вставку данных:

```sql
learning=*# insert into persons(first_name, second_name) values('sergey', 'sergeev');
INSERT 0 1
```

Во второй консоли делаем выборку данных:

```sql
learning=*# select * from persons;
 id | first_name | second_name
----+------------+-------------
  1 | ivan       | ivanov
  2 | petr       | petrov
(2 строки)
```

Данных, вставленных в первой консоли не видно, потому что уровень изоляции - read committed. При данном уровне транзакция видит только те данные, которые были зафиксированы до начала запроса; он никогда не увидит незафиксированных данных или изменений, внесённых в процессе выполнения запроса параллельными транзакциями.
Выполнив COMMIT в первой консоли, выборка данных во второй покажет следующее:

```sql
learning=*# select * from persons;
 id | first_name | second_name
----+------------+-------------
  1 | ivan       | ivanov
  2 | petr       | petrov
  3 | sergey     | sergeev
(3 строки)
```

Данные в параллельной транзакции зафиксированы, поэтому мы их видим.

### тестируем repeatable read

Выполняем в обеих консолях транзакции с уровнем repeatable read:

```sql
learning=# BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN
learning=*# 
```

В первой консоли выполняем вставку:

```sql
learning=*# insert into persons(first_name, second_name) values('sveta', 'svetova');
INSERT 0 1
learning=*# 
```

Во второй консоли выполняем выборку:

```sql
learning=*# select * from persons;
 id | first_name | second_name
----+------------+-------------
  1 | ivan       | ivanov
  2 | petr       | petrov
  3 | sergey     | sergeev
(3 строки)
```

В первой завершим транзакцию командой COMMIT. Во второй снова выполним выборку - получим тот же результат.
Завершив транзакцию во второй консоли получим результат:

```sql
learning=*# commit;
COMMIT
learning=# select * from persons;
 id | first_name | second_name
----+------------+-------------
  1 | ivan       | ivanov
  2 | petr       | petrov
  3 | sergey     | sergeev
  5 | sveta      | svetova
(4 строки)
```

В режиме Repeatable Read видны только те данные, которые были зафиксированы до начала транзакции, но не видны незафиксированные данные и изменения, произведённые другими транзакциями в процессе выполнения данной транзакции. Последовательные команды SELECT в одной транзакции видят одни и те же данные; они не видят изменений, внесённых и зафиксированных другими транзакциями после начала их текущей транзакции.

Значит в режиме RR во второй транзакции мы не увидим изменений первой пока не завершим обе.
