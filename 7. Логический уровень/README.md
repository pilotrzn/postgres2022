# Домашнее задание



```text
 Стенд: VirtualBox
 OS: Ubuntu 20.04
```

```bash
NAME="Ubuntu"
VERSION="20.04.5 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.5 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
```

Версия Postgres:

```sql
postgres=# select version();
version
PostgreSQL 14.6 (Ubuntu 14.6-1.pgdg20.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, 64-bit
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
     
    Выводим список пользователей:

    ![pg_users][1]

    [1]: ../img/pg_du.png

    Пользователи созданы, но не имеют прав на вход. Поэтому дополнительно дадим права на вход(LOGIN):

    ```sql
    postgres=# alter role readonly LOGIN ;
    ALTER ROLE
    postgres=# alter role testread LOGIN;
    ALTER ROLE
    ```
    если не дать права login,подключиться не сможем.
 

6. Пробуем подключиться:

    ```bash
    alex@pg14-srv01:~$ psql -U testread -d testdb
    psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL:  Peer authentication failed for user "testread"
    ```

    В данном случае не удалось подключиться, потому что в hba.conf выставлен метод проверки подлинности - peer. Этот метод получает имя пользователя операционной системы.

    Решение:
    - правим файл pg_hba.conf - ставим метод проверки подлинности md5 для local all all. в ОС ubuntu этот файл по умолчанию расположен /etc/postgresql/14/main/pg_hba.conf
    - для пользователя postgres можем сделать метод trust, или md5 и создать файл .pgpass в домашнем каталоге пользователя postgres, чтобы не вводить пароль каждый раз. Данный вариант подразумевает, что кроме postgres  никто не может входить на сервер локально.
    - в psql выполняем select pg_reload_conf();

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

8. Пробуем создать таблицу от имени пользователя testread:

    ```sql
    testdb=> create table t2(c1 integer); 
    CREATE TABLE
    testdb=> insert into t2 values (2);
    INSERT 0 1
    ```

    создать таблицу удалось, но она создана в схеме public. Как результат - все будут создавать базы в схеме public, что не желательно. Схема используется в служебных целях.
    Чтобы запретить создание таблиц в схеме public, нужно забрать эти права у пользователя:

    ```sql
    testdb=# revoke CREATE on SCHEMA public FROM public;
    REVOKE
    ```

    дополнительно можно изьять все права на схему public нашей базы:

    ```sql
    testdb=# revoke all on DATABASE testdb FROM public; 
    REVOKE
    ```

    Теперь при попытке создать таблицу получим ошибку:

    ```sql
    testdb=> create table t3(c1 integer); 
    ERROR:  permission denied for schema public
    LINE 1: create table t3(c1 integer);
                        ^
    testdb=>
    ```