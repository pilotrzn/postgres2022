# Домашнее задание

## Тестовый стенд

Состоит из 4 ВМ

```text
 Стенд: VirtualBox
 OS: Ubuntu 20.04
 CPU: 2
 RAM: 2GB
 Каталог для БД: vdi 10gb, примонтирован в /var/lib/postgresql/14
```

```bash
NAME="Ubuntu"
VERSION="20.04.5 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.5 LTS"
VERSION_ID="20.04"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
```

### Версия Postgres

```sql
postgres=# select version();
version
PostgreSQL 14.6 (Ubuntu 14.6-1.pgdg20.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, 64-bit
(1 строка)
```

### Предварительное конфигурирование

- В начале задания каждый кластер standalone.
- Конфигурация postgresql.conf подстроена под параметры RAM и CPU, настроены huge_pages.
- На каждой ВМ настроен файл /etc/hosts для обращения по имени хоста.
- На каждом кластере создана роль:

    ```sql
    postgres=# create role replicator password '123456' login inherit replication;
    CREATE ROLE
    ```

- Параметр wal_level = logical;
- Параметр syncronous_commit = on;
- В файл pg_hba.conf добавлены записи:

    ```text
    host all postgres 192.168.56.1/0 md5
    host all replicator 192.168.56.1/0 md5
    ```

## Логическая репликация 2 ВМ

### Создание таблиц ВМ1

на ВМ1 создаем таблицу с произвольно сгенерированными данными. Сейчас не важно содержимое:

```sql
postgres=# \c testdb
Вы подключены к базе данных "testdb" как пользователь "postgres".
testdb=# create table first_table as select generate_series(1,50) as id,md5(random()::text)::char(25) as fio;
SELECT 50
```

Для созданной таблицы создадим публикацию и проверим состояние публикации:

```sql
testdb=# create publication first_pub for table first_table;
CREATE PUBLICATION
testdb=# \dRp+
                                   Публикация first_pub
 Владелец | Все таблицы | Добавления | Изменения | Удаления | Опустошения | Через корень 
----------+-------------+------------+-----------+----------+-------------+--------------
 postgres | f           | t          | t         | t        | t           | f
Таблицы:
    "public.first_table"
```

Создаем таблицу  second_table для подписи на публикацию 2 ВМ. Таблицу не заполняем:

```sql
testdb=# create table second_table (id int ,name text);
CREATE TABLE
testdb=# \d+ second_table 
                                                  Таблица "public.second_table"
 Столбец |   Тип   | Правило сортировки | Допустимость NULL | По умолчанию | Хранилище | Сжатие | Цель для статистики | Описание 
---------+---------+--------------------+-------------------+--------------+-----------+--------+---------------------+----------
 id      | integer |                    |                   |              | plain     |        |                     | 
 name    | text    |                    |                   |              | extended  |        |                     | 
Метод доступа: heap

```

### Создание таблиц ВМ2

На второй ВМ создаем аналогичные таблицы, но не заполняем данными. Создаем публикацию для второй таблицы:

```sql
testdb=# CREATE TABLE public.first_table (id integer,fio character(25));
CREATE TABLE
testdb=# create table second_table (id int ,name text);
CREATE TABLE
testdb=# create publication second_pub for table second_table ;
CREATE PUBLICATION
```

### Создание подписок на обеих ВМ

Прежде чем начать создавать подписки, дадим права на чтение наших таблиц пользователю replicator на обеих ВМ:

```sql
testdb=# grant SELECT on TABLE first_table to replicator ;
GRANT
testdb=# grant SELECT on TABLE second_table to replicator ;
GRANT
```

на второй ВМ создаем подписку:

```sql
testdb=# create subscription first_sub CONNECTION 'host=pg14-srv01 user=replicator dbname=testdb password=123456' publication first_pub with(copy_data=true);
NOTICE:  created replication slot "first_sub" on publisher
CREATE SUBSCRIPTION
testdb=# \dRs
               Список подписок
    Имя    | Владелец | Включён | Публикация  
-----------+----------+---------+-------------
 first_sub | postgres | t       | {first_pub}
(1 строка)
```

На первой ВМ создаем подписку:

```sql
testdb=# create subscription second_sub CONNECTION 'host=pg14-srv02 user=replicator dbname=testdb password=123456' publication second_pub with(copy_data=true);
NOTICE:  created replication slot "second_sub" on publisher
CREATE SUBSCRIPTION
testdb=# \dRs
                Список подписок
    Имя     | Владелец | Включён |  Публикация  
------------+----------+---------+--------------
 second_sub | postgres | t       | {second_pub}
(1 строка)
```

Далее "за кадром" выполнил проверку наличия данных в подписках, проверил работоспособность репликации -  сделал INSERT в опубликованные таблицы, выполнил SELECT в подписках. Данные реплицировались. 

В таком варианте репликации крайне важно следить где публикация а где подписка. Если внести данные в таблицу, которая является подпиской, может развалиться репликация.

### Репликация на 3 ВМ

Третья ВМ настроена аналогично остальным, так же включен параметр wal_level=logical.

Создаем БД и таблицы :

```sql
postgres=# create database testdb;
CREATE DATABASE
postgres=# \c testdb
Вы подключены к базе данных "testdb" как пользователь "postgres".
testdb=# CREATE TABLE public.second_table (id integer,name text);
CREATE TABLE
testdb=# CREATE TABLE public.first_table (id integer,fio character(25));
CREATE TABLE
testdb=# grant SELECT on TABLE first_table to replicator ;
GRANT
testdb=# grant SELECT on TABLE second_table to replicator ;
GRANT
```

Теперь выполним подписку на таблицы - first_table ВМ1, second_table ВМ2:

```sql
testdb=# create subscription first_sub3vm CONNECTION 'host=pg14-srv01 user=replicator dbname=testdb password=123456' publication first_pub with(copy_data=true);
NOTICE:  created replication slot "first_sub3vm" on publisher
CREATE SUBSCRIPTION
testdb=# create subscription second_sub3vm CONNECTION 'host=pg14-srv02 user=replicator dbname=testdb password=123456' publication second_pub with(copy_data=true);
NOTICE:  created replication slot "second_sub3vm" on publisher
CREATE SUBSCRIPTION
```

Обращаю внимание, что имена подписок должны отличаться от имен других серверов, так как это имя слота репликации!!!
Ниже листинг слотов:

ВМ1

```sql
postgres=# select * from pg_replication_slots \gx
-[ RECORD 1 ]-------+-------------
slot_name           | first_sub
plugin              | pgoutput
slot_type           | logical
datoid              | 16384
database            | testdb
temporary           | f
active              | t
active_pid          | 949
xmin                |
catalog_xmin        | 80964105
restart_lsn         | 38/9F000060
confirmed_flush_lsn | 38/9F000098
wal_status          | reserved
safe_wal_size       |
two_phase           | f
-[ RECORD 2 ]-------+-------------
slot_name           | first_sub3vm
plugin              | pgoutput
slot_type           | logical
datoid              | 16384
database            | testdb
temporary           | f
active              | t
active_pid          | 2028
xmin                |
catalog_xmin        | 80964105
restart_lsn         | 38/9F000060
confirmed_flush_lsn | 38/9F000098
wal_status          | reserved
safe_wal_size       |
two_phase           | f
```

ВМ2

```sql
postgres=# select * from pg_replication_slots \gx
-[ RECORD 1 ]-------+--------------
slot_name           | second_sub
plugin              | pgoutput
slot_type           | logical
datoid              | 16385
database            | testdb
temporary           | f
active              | t
active_pid          | 878
xmin                |
catalog_xmin        | 895
restart_lsn         | 0/18000060
confirmed_flush_lsn | 0/18000098
wal_status          | reserved
safe_wal_size       |
two_phase           | f
-[ RECORD 2 ]-------+--------------
slot_name           | second_sub3vm
plugin              | pgoutput
slot_type           | logical
datoid              | 16385
database            | testdb
temporary           | f
active              | t
active_pid          | 1966
xmin                |
catalog_xmin        | 895
restart_lsn         | 0/18000060
confirmed_flush_lsn | 0/18000098
wal_status          | reserved
safe_wal_size       |
two_phase           | f
```

Проверим наличие данных:

```sql
testdb=# select * from first_table limit 10;
 id |            fio
----+---------------------------
  1 | 6bb9efb509026fd2af1e0473a
  2 | fa2811aaa8bc9cda768e5b52a
  3 | 399779a8a85a1c3caeeaa51b0
  4 | 0bf377fd0149f884fd5689cdc
  5 | 8bb56ea1e2c018182baf863b6
  6 | 2d04f011b7f5d3207591b31c7
  7 | d8370f7dfba092299f8d0ea20
  8 | 157366bf3a8be99d7d64c3c7c
  9 | 7131fe579a781a4985595c25d
 10 | 50a9d36aef34f19d7470a4778
(10 строк)

testdb=# select * from second_table ;
 id |  name
----+--------
  1 | ivanov
  2 | petrov
(2 строки)
```

При настройке не возникло проблем.

## Создание горячего резерва

Для получения горячего резерва будем создавать физическую реплику ВМ3. Для начала скопируем содержимое файла postgresql.conf, скорректируем параметры sysctl(huge_pages).
Чтобы удалось подключение реплики добавим запись в pg_hba.conf:

```
host replication postgres 192.168.56.1/0 md5
```

На ВМ3 параметр

- synchronous_commit = on.

На ВМ4 параметр

- hot_standy_feedback=off;
- max_standby_streaming_delay = 30s.

На ВМ4 ранее созданный кластер останавливаем и удаляем.
Далее выполняю команду pg_basebackup для создания физической копии сервера, но с ключом -R, чтобы создался файл recovery.conf:

```bash
postgres@pg14-srv04:~$ pg_basebackup -h pg14-srv03 -p 5432 -R -D /var/lib/postgresql/14/main
Пароль:
```

Запрошен пароль, вводим.
После завершения команды запускаем сервер postgres любым способом(я стартую службу).
Проверим состояние репликации. На мастере(ВМ3):

```sql
postgres=# select * from pg_stat_replication \gx
-[ RECORD 1 ]----+------------------------------
pid              | 4798
usesysid         | 10
usename          | postgres
application_name | walreceiver
client_addr      | 192.168.56.113
client_hostname  |
client_port      | 51338
backend_start    | 2022-12-25 21:09:21.710704+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/F000060
write_lsn        | 0/F000060
flush_lsn        | 0/F000060
replay_lsn       | 0/F000060
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2022-12-25 21:20:13.0952+00
```

На реплике(ВМ4):

```sql
testdb=# select * from pg_stat_wal_receiver \gx
-[ RECORD 1 ]-----------------------------------------
pid                   | 1508
status                | streaming
receive_start_lsn     | 0/F000000
receive_start_tli     | 1
written_lsn           | 0/F000060
flushed_lsn           | 0/F000060
received_tli          | 1
last_msg_send_time    | 2022-12-25 21:18:22.774983+00
last_msg_receipt_time | 2022-12-25 21:18:22.781493+00
latest_end_lsn        | 0/F000060
latest_end_time       | 2022-12-25 21:09:21.738573+00
slot_name             |
sender_host           | pg14-srv03
sender_port           | 5432
conninfo              | user=postgres password=******** channel_binding=prefer dbname=replication host=pg14-srv03 port=5432 fallback_application_name=walreceiver sslmode=prefer sslcompression=0 sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres target_session_attrs=any
```

Запрос SELECT к обеим таблицам на реплике показал содержимое таблиц. "За кадром" выполнил INSERT в таблицу first_table  на ВМ1. на ВМ4 выполнил SELECT - новые данные успешно среплицировались.

Не столкнулся с проблемами при создании реплики на 4ВМ. Но могу сказать что в данной ситуации выполнить promote без проблем не получится. У нас подписки настроены на текущий мастер, а после переключения на новом мастере не уверен что все пройдет гладко, возможно возникнут ошибки с имеющимися слотами репликаций на публикантах. Для этого нужно провести дополнительные тестирования.
Из вопросов, возникших к реализации - не совсем понятно, почему подписка не может использовать файл pgpass, нужно обязательно прописывать пароль явно. Этот пароль можно увидеть при выводе команды `/dRs+`...
