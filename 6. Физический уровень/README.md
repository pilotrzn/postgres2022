# Домашнее задание.

```text
 Стенд: VirtualBox
 OS: Ubuntu 22.04
```

```bash
alex@ubuntu-srv1:~$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.1 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
```

Версия Postgres:

```sql
postgres=# select version();
version
PostgreSQL 14.6 (Ubuntu 14.6-1.pgdg22.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0, 64-bit
(1 строка)
```

Создаем тестовую БД learning:

```sql
postgres=# create database learning;
CREATE DATABASE
```

подключаемся к созданной базе, создаем таблицу tbl1

```sql
postgres=# \c learning
Вы подключены к базе данных "learning" как пользователь "postgres".
learning=# create table tbl1(id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
learning(# message text);
CREATE TABLE
learning=# \d tbl1
                                   Таблица "public.tbl1"
 Столбец |   Тип   | Правило сортировки | Допустимость NULL |         По умолчанию
---------+---------+--------------------+-------------------+------------------------------
 id      | integer |                    | not null          | generated always as identity
 message | text    |                    |                   |
Индексы:
    "tbl1_pkey" PRIMARY KEY, btree (id)
```

Вставляем произвольные данные для дальнейшей проверки:

```sql
INSERT INTO tbl1 (message)
VALUES  ('2021-11-01_раз'),
        ('2021-11-10_два'),
        ('2021-11-30_три'),
        ('2021-12-30_четыре'),
        ('2021-12-31_пять'),
        ('2022-01-01_шесть'),
        ('2022-01-01_семь');
```

В консоли управление VirtualBox создаем VMDK диск. Останавливаем машину с установленным postgres, подключаем диск, монтируем его в каталог /data (/etc/fstab). в моем случае это диск /dev/sdb1
Cоздаем каталог:

```bash
alex@ubuntu-srv1:~$ sudo mount /dev/sdb1 /data ## если монтирование выполнено в fstab - пропускаем
alex@ubuntu-srv1:~$ sudo mkdir -p /data/main
alex@ubuntu-srv1:~$ sudo hown postgres:postgres /data/main
alex@ubuntu-srv1:~$ sudo chmod 700 /data/main
```

С помощью команды mv переносим содержимое каталога /var/lib/postgresql/14/main/ в каталог /data/main. Обязатально проверяем права.

Чтобы перенесенный кластер завработал необходимо поменять параметр в файле /etc/postgresql/14/main/postgresql.conf:

```text
data_directory = '/data/main'
```

Запускаем службу postgres.
Подключаемся к psql и запрашиваем data_directory:

```sql
postgres=# show data_directory;
  data_directory
------------------
 /data/main
(1 строка)
```

Дополнительное задание. Перенос диска с базой на другой инстанс
Пошаговое описание.

1. разворачиваем новую ВМ
2. устанавливаем postgresql-14. каталог бд по дефолту /var/lib/postgresql/14/main
3. Останавливаем postgresql на первой ВМ, останавливаем ВМ(нельзя настроить одновременное использование диска на 2 машинах, вариант использовать общие папки)
4. останавливаем новую ВМ, в настройках Virtualbox подключаем ранее созданный VMDK диск. Запускаем ВМ.
5. Останавливаем службу postgresql(systemctl stop postgresql.service), удаляем каталог /var/lib/postgresql/14/main/
6. монтируем диск в каталог /var/lib/postgresql/14. в моем случае это

    ```bash
    alex@ubuntu-srv1:~$ sudo mount /dev/sdb1 /var/lib/postgresql/14/ 
    ```

    можно так же примонтировать с помощью fstab.
    выполнив запрос ls -l получим:

    ```bash
    alex@ubuntu-srv1:~# sudo ls -l /var/lib/postgresql/14
    total 20
    drwx------  2 root     root     16384 ноя 14 19:50 lost+found
    drwx------ 19 postgres postgres  4096 ноя 14 21:13 main
    ```

7. запускаем службу postgresql(systemctl start postgresql.service)
8. подклюаемся в psql под пользователем postgres(sudo -iu postgres psql)
9. выводим список баз:

```sql
postgres-# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 learning  | postgres | UTF8     | ru_RU.UTF-8 | ru_RU.UTF-8 |
 postgres  | postgres | UTF8     | ru_RU.UTF-8 | ru_RU.UTF-8 |
 template0 | postgres | UTF8     | ru_RU.UTF-8 | ru_RU.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | ru_RU.UTF-8 | ru_RU.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)
```

как видим, база, которую мы создали на первой ВМ так же присутствует тут.
для проверки можем создать тестовую БД, и увидим что Postgres полностью работоспособен(не в режиме readonly).
