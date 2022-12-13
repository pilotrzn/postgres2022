# Домашнее задание

```text
 Стенд: VirtualBox
 OS: Ubuntu 20.04
 CPU: 4
 RAM: 4GB
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

Версия Postgres:

```sql
postgres=# select version();
version
PostgreSQL 14.6 (Ubuntu 14.6-1.pgdg20.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, 64-bit
(1 строка)
```

Рараметры сервера в postgresql.conf:
```text
max_connections = 60
shared_buffers = 1GB
effective_cache_size = 3GB
maintenance_work_mem = 320MB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 500
random_page_cost = 4
effective_io_concurrency = 2
work_mem = 6553kB
min_wal_size = 4GB
max_wal_size = 16GB
```

Для провердения тестов будем использовать не дефолтную БД postgres, а созданную раннее базу testdb(задал коэффициент 100,чтобы было больше записей):

1. иннициализируем pgbench, создаем большое количество записей в бд:
```bash
postgres@pg14-srv01:~$ pgbench -i -s 100  testdb
dropping old tables...
NOTICE:  table "pgbench_accounts" does not exist, skipping
NOTICE:  table "pgbench_branches" does not exist, skipping
NOTICE:  table "pgbench_history" does not exist, skipping
NOTICE:  table "pgbench_tellers" does not exist, skipping
creating tables...
generating data (client-side)...
10000000 of 10000000 tuples (100%) done (elapsed 15.30 s, remaining 0.00 s)
vacuuming...
creating primary keys...
done in 26.70 s (drop tables 0.01 s, create tables 0.02 s, client-side generate 15.39 s, vacuum 4.88 s, primary keys 6.40 s).
```

2. далее выполняем несколько синтетических тестов с помощью утилиты pgbench.
    Выполнять будем с разными настройками автовакуума.
    - тест с выключенным автовакууумом;
    - тест с автовакуумом, настроенным поумолчанию
    - тест с измеменнными парамертами(агрессивные параметры)
    - тест с параметрами, показавшими меньшее расхождение ппоказателя tps.

Параметры тестирования:
  - 8 коннектов в течении 10 минут.

Пример результата при выключенном автовакууме:

```bash
postgres@pg14-srv01:~/14/main$ pgbench -c 8 -P 60 -T 600 testdb
pgbench (14.6 (Ubuntu 14.6-1.pgdg20.04+1))
starting vacuum...end.
progress: 60.0 s, 2573.2 tps, lat 3.063 ms stddev 2.434
progress: 120.0 s, 2096.9 tps, lat 3.771 ms stddev 3.724
progress: 180.0 s, 2360.4 tps, lat 3.348 ms stddev 3.370
progress: 240.0 s, 2217.1 tps, lat 3.565 ms stddev 3.542
progress: 300.0 s, 2270.7 tps, lat 3.482 ms stddev 3.605
progress: 360.0 s, 2217.8 tps, lat 3.564 ms stddev 3.511
progress: 420.0 s, 2169.7 tps, lat 3.643 ms stddev 3.503
progress: 480.0 s, 2390.8 tps, lat 3.303 ms stddev 3.003
progress: 540.0 s, 2387.5 tps, lat 3.311 ms stddev 3.100
progress: 600.0 s, 2298.0 tps, lat 3.433 ms stddev 3.455
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 1378938
latency average = 3.438 ms
latency stddev = 3.333 ms
initial connection time = 22.267 ms
tps = 2298.245555 (without initial connection time)

```

параметры "агрессивные"(рекомендация с занятия, протестировано):
```text
autovacuum_vacuum_scale_factor = '0.05'
log_autovacuum_min_duration = '0'
autovacuum_max_workers = '4'
autovacuum_naptime = '15'
autovacuum_vacuum_threshold = '25'
autovacuum_vacuum_cost_delay = '10'
autovacuum_vacuum_cost_limit = '1000'
```

Далее результаты покажу просто в виде таблицы и графика.

 ![table_result][1]

[1]: ../img/result_table.png

 - off - результаты без автовакуума
 - default - параметры автовауума по умолчанию
 - tune1 - настройка из примера с занятия
 - tune2 - результаты, полученные после нескольких тестов и изменениями параметров автовакуума.

 ![chart][2]

[2]: ../img/result_chart.png


Список параметров автовакуума:

```text
autovacuum_analyze_scale_factor = '0.08'
autovacuum_vacuum_scale_factor = '0.1'
log_autovacuum_min_duration = '0'
autovacuum_max_workers = '4'
autovacuum_naptime = '15'
autovacuum_vacuum_threshold = '25'
autovacuum_vacuum_cost_delay = '10'
autovacuum_vacuum_cost_limit = '1000'
```

плюс для самой большой таблицы добавил параметр autovacuum_vacuum_threshold=500.

В таблице видно, что общее количество транзакции проседало только при дефолтных настройках, после изменения количество приблизилось к исходному.
Но  реальные данные могут сильно отличаться от результатов синтетических тестов.

