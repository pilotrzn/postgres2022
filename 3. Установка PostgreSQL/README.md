# Домашнее задание. Установка PostgreSQL в Docker

стенд:
Debian 11
Docker 

для сервера используем образ postgres
```
$ docker pull postgres:latest
```

Создаем каталог(от root):
```
# mkdir -p var/lib/postgresql
```
Создаем docker сеть:
```
$ docker network create postgresnet 
```

Выполняем команду для создания контейнера(1):
```
$ docker run --name pg-server --network postgresnet \
-e POSTGRES_PASSWORD=postgres \
-d -p 5432:5432 \
-v ./dockers/postgres:/var/lib/postgresql/data postgres:latest
```

Проверяем состояние контейнера
```
$ docker ps 
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS                   PORTS                    NAMES
e42ef1c004de   postgres:latest   "docker-entrypoint.s…"   8 seconds ago   Up 6 seconds             0.0.0.0:5432->5432/tcp   pg-server
```

Для проверки работоспособности запускаем еще один докер в интерактивном режиме подключаемся к сети(2): 

```
$ docker run -it --rm --network postgresnet --name pg-client postgres:latest psql -h pg-server -U postgres
```
Появляется запрос пароля. Вводим и входим в консоль postgres
Для тестирования создаем базы:
```
postgres=# create database test1;
postgres=# create database test2;
```
Выходим из консоли. 
Выполняем остановку и удаление контейнера.
```
$ docker stop pg-server
$ docker rm pg-server
```
Далее повторить создание командой (1).
Снова запустить клиента командой (2). Вывести список баз. 
```
postgres=# \l
                                                List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    | ICU Locale | Locale Provider |   Access privileges
-----------+----------+----------+------------+------------+------------+-----------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | =c/postgres          +
           |          |          |            |            |            |                 | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | =c/postgres          +
           |          |          |            |            |            |                 | postgres=CTc/postgres
 test1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            |
 test2     | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            |
(5 rows)
```
Как видим, базы на месте.

Для эксперимента установим pgAdmin в докер контейнер.
```
$ docker run -p 5050:80  \
-e "PGADMIN_DEFAULT_EMAIL=name@example.com" \
-e "PGADMIN_DEFAULT_PASSWORD=admin"  \
-d dpage/pgadmin4
```
В моем случае подключение к pgAdmin осуществлял на другом компьютере в локальной сети. В браузере по адресу https://192.168.1.11:5050. После настроек подключения (192.168.1.11:5432) в окне pgAdmin видим следующую картину.

![pgadmin][1]

[1]: ../img/pgadmin.png

