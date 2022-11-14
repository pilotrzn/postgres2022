# Домашнее задание



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

1. Создаем базу:

    ```sql
    postgres=# create database testdb;
    CREATE DATABASE
    postgres=# \c testdb
    Вы подключены к базе данных "testdb" как пользователь "postgres".
    testdb=#
    ```

2. Создаем схему:

    ```sql
    testdb=# create schema testnm;
    CREATE SCHEMA
    ```

3. Создаем таблицу, вставляем в нее значение:

    ```sql
    testdb=# create table testnm.t1 (c1 integer);
    CREATE TABLE
    testdb=# insert into testnm.t1 (c1) values (1),(2),(15);
    INSERT 0 3
    ```

4. Создаем роль только для чтения. назначаем права.

    ```sql
    testdb=# CREATE ROLE readonly;
    CREATE ROLE
    testdb=# grant CONNECT ON DATABASE testdb TO readonly ;
    GRANT
    testdb=# GRANT USAGE on SCHEMA testnm to readonly ;
    GRANT
    testdb=# GRANT SELECT on TABLE testnm.t1 to readonly;
    GRANT
    ```

5. Создаем роль с паролем, даем права:

    ```sql
    testdb=# create role testread with password 'test123';
    CREATE ROLE
    testdb=# GRANT readonly to testread ;
    GRANT ROLE
    ```

6. Пробуем подключиться:
    ```bash
    postgres@ubuntu-srv1:~$ psql -U testread -d testdb
    psql: ошибка: подключиться к серверу через сокет "/var/run/postgresql/.s.PGSQL.5432" не удалось: ВАЖНО:  пользователь "testread" не прошёл проверку подлинности (Peer)
    ```

    В данном случае не удалось подключиться по причине отсутствия разрешения в hba.conf

    Решение:
    - правим файл pg_hba.conf - ставим метод проверки подлинности md5 для local all all
    - в psql выполняем select pg_reload_conf();

    Пробуем подлкючиться:

    ```bash
    postgres@ubuntu-srv1:~$ psql -U testread -d testdb
    Пароль пользователя testread:
    psql: ошибка: подключиться к серверу через сокет "/var/run/postgresql/.s.PGSQL.5432" не удалось: ВАЖНО:  для роли "testread" вход запрещён
    postgres@ubuntu-srv1:~$
    ```

    В данном случае выясняем что отсутствуют права на вход. то есть при создании ролей не указан параметр LOGIN. По-умолчанию в postgres роли задается параметр NOLOGIN.
    Выполняем:

    ```sql
    postgres=# alter role testread LOGIN ;
    ALTER ROLE
    ```

    Пробуем подключиться к БД:

    ```bash
    postgres@ubuntu-srv1:~$ psql -U testread -d testdb
    Пароль пользователя testread:
    psql (14.6 (Ubuntu 14.6-1.pgdg22.04+1))
    Введите "help", чтобы получить справку.
    testdb=>
    ```
 
    Пробуем посмотреть список таблиц:

    ```sql
    testdb=> \dt
    Отношения не найдены.
    testdb=> \dn
    Список схем
      Имя   | Владелец
    --------+----------
    public | postgres
    testnm | postgres
    (2 строки)
    ```

    Список табиц командой /dt не выводится, потому что:
    - таблица создана в схеме testnm
    - путь по умолчанию задан:

        ```sql
        testdb=> show search_path ;
        search_path
        -----------------
        "$user", public
        (1 строка)
        ```

        По умолчанию поиск идет в схеме с именем как имя пользователя, иначе в public.

7. Выполняем запрос, обратившись с явным указанием схемы:

    ```sql
    testdb=> select * from testnm.t1 ;
    c1 
    ----
    1    
    2
    15
    (3 строки)
    ```

    Варианты решения, чтобы не вводить схему:
    
