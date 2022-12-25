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

### Версия Postgres:

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

- Параметр wal_level = replica;

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



