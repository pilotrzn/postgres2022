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
work_mem = 8MB
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
    - тест с автовакуумом, настроенным по-умолчанию
    - тест с измененными параметрами(как пример взял из занятия)
    - тесты с параметрами, показавшими меньшее расхождение ппоказателя tps.

Параметры тестирования:
  - 8 коннектов в течении 10 минут.

Пример результата одного из тестов

```bash
postgres@pg14-srv01:~/14/main$ pgbench -c 8 -P 60 -T 600 testdb
pgbench (14.6 (Ubuntu 14.6-1.pgdg20.04+1))
starting vacuum...end.
progress: 60.1 s, 1569.9 tps, lat 5.074 ms stddev 12.214
progress: 120.0 s, 2120.0 tps, lat 3.778 ms stddev 11.244
progress: 180.0 s, 2516.7 tps, lat 3.172 ms stddev 4.479
progress: 240.0 s, 2160.6 tps, lat 3.699 ms stddev 6.222
progress: 300.0 s, 2282.6 tps, lat 3.500 ms stddev 7.389
progress: 360.0 s, 1453.0 tps, lat 5.499 ms stddev 12.215
progress: 420.0 s, 1993.5 tps, lat 4.007 ms stddev 7.493
progress: 480.0 s, 2317.4 tps, lat 3.447 ms stddev 5.218
progress: 540.0 s, 2118.7 tps, lat 3.770 ms stddev 7.211
progress: 600.0 s, 2055.5 tps, lat 3.885 ms stddev 9.454
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 1235255
latency average = 3.880 ms
latency stddev = 8.406 ms
initial connection time = 19.554 ms
tps = 2058.812309 (without initial connection time)
```

параметры из примера:
```text
autovacuum_vacuum_scale_factor = '0.05'
log_autovacuum_min_duration = '0'
autovacuum_max_workers = '4'
autovacuum_naptime = '15'
autovacuum_vacuum_threshold = '25'
autovacuum_vacuum_cost_delay = '10'
autovacuum_vacuum_cost_limit = '1000'
```

параметры tune1:

```text
log_autovacuum_min_duration = '0'
autovacuum_vacuum_scale_factor = '0.08'
autovacuum_vacuum_insert_scale_factor = '0.08'
log_autovacuum_min_duration = '0'
autovacuum_max_workers = '4'
autovacuum_naptime = '15s'
autovacuum_vacuum_threshold = '20'
autovacuum_vacuum_cost_delay = '10'
autovacuum_vacuum_cost_limit = '1000'
autovacuum_analyze_scale_factor = '0.2'
```


Далее результаты покажу просто в виде таблицы и графика.

 ![table_result][1]

[1]: ../img/result_table.png

 - off - результаты без автовакуума
 - default - параметры автовауума по умолчанию
 - sample - настройка из примера с занятия
 - tune1,2 - результаты, полученные после нескольких тестов и изменениями параметров автовакуума.

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

В результате множественных тестов я не пришел к какому-то единому решению. Разные варианты настроек при повторных тестах дают не совпадающие результаты. В приведенных примерах более менее, на мой взгляд, получилось добиться ровности в варианте tune1, где меньше всего скачков tps.  Неоднозначность показаний может зависеть от разных моментов, в том числе от стенда(пробовал вариант с размещением vdi диска с данными на отдельном ssd диске). И стоит отметить что синтетические тесты pgbench очень далеки от реальной работы систем с БД.

