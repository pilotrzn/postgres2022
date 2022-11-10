# Домашнее задание. Установка PostgreSQL в Docker

стенд:
Debian 11
Docker 

для сервера используем образ postgres
```
$ docker pull postgres
```

Для клиента postgresql ипользуем отдельный образ с клиентом
```
$ docker pull jbergknoff/postgresql-client:latest
```

Создаем каталог для БД

```
$ sudo mkdir /var/lib/postgresql
```

docker run --name pg_srv1 -d \
-e POSTGRES_PASSWORD=postgres \
-e POSTGRES_USER=postgres \
-e POSTGRES_DB=test1 -p 5432:5432 -v /home/alex/dockers/postgres/pg_cluster/data:/var/lib/postgresql/data postgres:latest
