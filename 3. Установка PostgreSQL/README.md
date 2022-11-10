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

version: '3'

volumes:
  pg_vol:

services:
  pg_db:
    image: postgres:latest
    restart: always
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_DB=testdb
    volumes:
      - pg_vol:/var/lib/postgresql
    ports:
      - 5432:5432