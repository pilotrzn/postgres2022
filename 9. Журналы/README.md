# Домашнее задание

## Тестовый стенд

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

### Версия Postgres:

```sql
postgres=# select version();
version
PostgreSQL 14.6 (Ubuntu 14.6-1.pgdg20.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, 64-bit
(1 строка)
```


### Параметры сервера в postgresql.conf

(добавлены параметры логирования, включен вывод только данных контрольных точек):

```text
max_connections = 60
shared_buffers = 1GB
effective_cache_size = 3GB
maintenance_work_mem = 256MB
checkpoint_timeout = '30s'
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
work_mem = 8MB
min_wal_size = 1GB
max_wal_size = 4GB
max_worker_processes = '4'
max_parallel_workers_per_gather = '2'
max_parallel_workers = '4'
max_parallel_maintenance_workers = '2'
log_checkpoints = 'on'
checkpoint_warning = '10s'
log_connections = 'off'
log_destination = 'stderr'
log_directory = 'log'
log_disconnections='off'
log_duration= 'off'
log_error_verbosity= 'default'
log_file_mode= '416'
log_filename= 'postgresql-%Y-%m-%d.log'
log_line_prefix= '%t [%p]: [%l-1] user=%u,db=%d,client=%h '
log_lock_waits= 'off'
log_min_duration_statement= '5s'
log_rotation_age= '1d'
log_rotation_size= '0'
log_statement= 'none'
log_temp_files= '0'
log_timezone= 'W-SU'
log_truncate_on_rotation= 'on'
logging_collector= 'on'
autovacuum_vacuum_scale_factor = '0.08'
autovacuum_vacuum_insert_scale_factor = '0.08'
log_autovacuum_min_duration = '-1'
autovacuum_max_workers = '4'
autovacuum_naptime = '15s'
autovacuum_vacuum_threshold = '20'
autovacuum_vacuum_cost_delay = '10'
autovacuum_vacuum_cost_limit = '1000'
autovacuum_analyze_scale_factor = '0.2'
```

## Синхронный режим

Выполним нагрузочное  тестирование с помощью pgbench, как в предыдущем задании. Предварительно запишем метки lsn до начала теста а так же сбросим статистику bgwriter.

Начальный lsn
```sql
postgres=# SELECT pg_current_wal_insert_lsn();
 pg_current_wal_insert_lsn 
---------------------------
 2F/45000028
(1 строка)
postgres=# select pg_stat_reset_shared('bgwriter') ;
```

### Запуск теста

Результат теста немного удивил, в прошлом задании не было достигнуто такой ровности.

```bash
postgres@pg14-srv01:~$ pgbench -c 8 -P 60 -T 600 testdb
pgbench (14.6 (Ubuntu 14.6-1.pgdg20.04+1))
starting vacuum...end.
progress: 60.0 s, 2157.9 tps, lat 3.701 ms stddev 1.677
progress: 120.0 s, 1910.9 tps, lat 4.181 ms stddev 6.287
progress: 180.0 s, 1901.3 tps, lat 4.200 ms stddev 6.735
progress: 240.0 s, 1915.0 tps, lat 4.170 ms stddev 6.654
progress: 300.0 s, 1913.0 tps, lat 4.175 ms stddev 7.100
progress: 360.0 s, 1953.7 tps, lat 4.088 ms stddev 6.888
progress: 420.0 s, 1857.8 tps, lat 4.298 ms stddev 7.666
progress: 480.0 s, 1903.5 tps, lat 4.196 ms stddev 7.437
progress: 540.0 s, 1651.1 tps, lat 4.840 ms stddev 10.244
progress: 600.0 s, 1793.8 tps, lat 4.454 ms stddev 7.994
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 1137489
latency average = 4.213 ms
latency stddev = 7.062 ms
initial connection time = 16.063 ms
tps = 1895.750876 (without initial connection time)
```

Конечный lsn

```sql
postgres=# SELECT pg_current_wal_insert_lsn();
 pg_current_wal_insert_lsn 
---------------------------
 31/1A1ABB90
(1 строка)
```

Выведем статистику:
```sql
postgres=# select * from pg_stat_bgwriter  \gx
-[ RECORD 1 ]---------+------------------------------
checkpoints_timed     | 20
checkpoints_req       | 0
checkpoint_write_time | 542932
checkpoint_sync_time  | 2480
buffers_checkpoint    | 854362
buffers_clean         | 25331
maxwritten_clean      | 0
buffers_backend       | 7263
buffers_backend_fsync | 0
buffers_alloc         | 535910
stats_reset           | 2022-12-18 16:29:29.999632+00
```

Судя по статистиике выполнено 20 КТ по расписанию и не было принудительных КТ.

### Расчет объема данных за время теста(в ГБ)

В итоге получилось примерно 7.3 Гб за 10 минут.

```sql
postgres=# SELECT ('31/1A1ABB90'::pg_lsn - '2F/45000028'::pg_lsn) / ( 1024 * 1024 * 1024 );
      ?column?      
--------------------
 7.3297565951943398
(1 строка)
```

Далее сделаем усредненный расчет:
7.329 / 10 = 0.7329  -  примерно 730 МБ в минуту. Контрольная точка выполняется каждые 30 сек, 2 раза в в минуту. Получается примерно 360Мб проходит за время одной контрольной точки. Так как параметр max_wal_size = 4GB, контрольных точек вне расписания не случается, потому что нет превышения верхней границы объема wal(4гб должно накопиться с момента выполнения КТ, тогда произойдет принудительная КТ).


## Асинхронный режим

Отключим параметр synchronous_commit = off и сравним результаты.

Выполним сброс статистики:

```sql
postgres=# select pg_stat_reset_shared('bgwriter') ;
```

 Убедимся, что статистика сброшена:

 ```sql
 postgres=# select * from pg_stat_bgwriter  \gx
-[ RECORD 1 ]---------+------------------------------
checkpoints_timed     | 0
checkpoints_req       | 0
checkpoint_write_time | 0
checkpoint_sync_time  | 0
buffers_checkpoint    | 0
buffers_clean         | 0
maxwritten_clean      | 0
buffers_backend       | 0
buffers_backend_fsync | 0
buffers_alloc         | 2
stats_reset           | 2022-12-18 17:10:19.495734+00
```

Выполним тот же тест. Сразу виден прирост количества tps. Причина такого подведения в том, что при асинхронном режиме фиксации сервер pg  сообщает об успешном завершении транзакции сразу при ее логическом завершении и не дожидается, пока транзакция попадет на диск. В таком режиме есть определенный риск потери данных в случае краха - база будут восстановлена до последней записи в wal. Это значит что последние транзакции могут не восстановиться. Данные из wal скидываются на диск каждые wal_writer_delay, которые в нашем случае равны 200мс. Согласно документации, так называемое окно риска(лаг между отчетом о завершении транзакции и фактическим подтверждением) составляет трехкратное значение wal_writer_delay. То есть в случае краха будут потеряны последние транзакции за примерсно 600мс. Данный вариант допустим не в каждой системе, тут требуется индивидуальный подход.

Результат теста

```sql
postgres@pg14-srv01:~$ pgbench -c 8 -P 60 -T 600 testdb
pgbench (14.6 (Ubuntu 14.6-1.pgdg20.04+1))
starting vacuum...end.
progress: 60.0 s, 5516.5 tps, lat 1.447 ms stddev 1.917
progress: 120.0 s, 4516.3 tps, lat 1.768 ms stddev 2.051
progress: 180.0 s, 4440.7 tps, lat 1.798 ms stddev 6.171
progress: 240.0 s, 4207.5 tps, lat 1.898 ms stddev 7.960
progress: 300.0 s, 4293.1 tps, lat 1.860 ms stddev 7.952
progress: 360.0 s, 4008.9 tps, lat 1.992 ms stddev 7.576
progress: 420.0 s, 3163.2 tps, lat 2.522 ms stddev 11.146
progress: 480.0 s, 4463.1 tps, lat 1.792 ms stddev 3.541
progress: 540.0 s, 4792.3 tps, lat 1.666 ms stddev 11.950
progress: 600.0 s, 3693.5 tps, lat 2.162 ms stddev 11.761
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 2585685
latency average = 1.853 ms
latency stddev = 7.803 ms
initial connection time = 17.668 ms
tps = 4309.495736 (without initial connection time)
```

Выведем статистику:

```sql
postgres=# select * from pg_stat_bgwriter  \gx
-[ RECORD 1 ]---------+------------------------------
checkpoints_timed     | 20
checkpoints_req       | 0
checkpoint_write_time | 520589
checkpoint_sync_time  | 7764
buffers_checkpoint    | 1230167
buffers_clean         | 201155
maxwritten_clean      | 1554
buffers_backend       | 131857
buffers_backend_fsync | 0
buffers_alloc         | 1062084
stats_reset           | 2022-12-18 17:10:19.495734+00
```

Как видим, отсутствуют checkpoints_req, значит КТ выполнялись только по расписанию. Количество КТ по расписанию = 20, что соответстует заданному параметру в 30 сек.

### Сравнение синхронного и асинхронного режима

В моем тесте виден реальный прирост производительности по tps:

```text
                tps       Общее количество транзакции за тест
Синхронный:     1895            1137489
Асинхронный:    4309            2585685
```

## Контрольные суммы

Создаем новый кластер в включенноый проверкой контрольных сумм

```bash
postgres@pg14-srv01:~$ pg_createcluster  14 test -- --data-checksums
Creating new PostgreSQL cluster 14/test ...
```

Новый кластер создан на порту 5433. Создадим бд и таблицу

```sqlpostgres=# create database test;
CREATE DATABASE
postgres=# \c test
Вы подключены к базе данных "test" как пользователь "postgres".
test=# create table t1(id int);
CREATE TABLE
test=# insert into t1(id) values(1),(2),(4),(8);
INSERT 0 4
test=# select * from t1 ;
 id 
----
  1
  2
  4
  8
(4 строки)
```

Выясним в каком файле хранится таблица:

```sql
test=# SELECT pg_relation_filepath('t1');
 pg_relation_filepath 
----------------------
 base/16384/16385
(1 строка) 
```

Воспользуемся примером из занятия.
Остановим сервер и поменяем несколько байтов в странице (сотрем из заголовка LSN последней журнальной записи)

```bash
postgres@pg14-srv01:~$ pg_ctlcluster 14 test stop
postgres@pg14-srv01:~$ dd if=/dev/zero of=/var/lib/postgresql/14/test/base/16384/16385 oflag=dsync conv=notrunc bs=1 count=8
8+0 записей получено
8+0 записей отправлено
8 байт скопировано, 0,0273404 s, 0,3 kB/s
postgres@pg14-srv01:~$ 
```

После изменений запускаем сервер  и пробуем выбрать данные из таблицы:

```bash
postgres@pg14-srv01:~$ pg_ctlcluster 14 test start
Warning: the cluster will not be running as a systemd service. Consider using systemctl:
  sudo systemctl start postgresql@14-test
postgres@pg14-srv01:~$ pg_ctlcluster 14 test status
pg_ctl: сервер работает (PID: 8362)
/usr/lib/postgresql/14/bin/postgres "-D" "/var/lib/postgresql/14/test" "-c" "config_file=/etc/postgresql/14/test/postgresql.conf"
```

Сервер запустился. Заходим в psql порт 5433, подключаемся к базе test и выполняем select.

```sql
postgres@pg14-srv01:~$ psql -p 5433
psql (14.6 (Ubuntu 14.6-1.pgdg20.04+1))
Введите "help", чтобы получить справку.

postgres=# \c test
Вы подключены к базе данных "test" как пользователь "postgres".
test=# select * from t1 ;
ПРЕДУПРЕЖДЕНИЕ:  ошибка проверки страницы: получена контрольная сумма 61016, а ожидалась - 45049
ОШИБКА:  неверная страница в блоке 0 отношения base/16384/16385
```

Получаем ошибку контрольной суммы. Чтобы получать результат запроса можно включить параметр ignore_checksum_failure:

```sql
postgres=# alter system set ignore_checksum_failure to on;
ALTER SYSTEM
postgres=# show ignore_checksum_failure ;
 ignore_checksum_failure 
-------------------------
 off
(1 строка)

postgres=# select pg_reload_conf();
 pg_reload_conf 
----------------
 t
(1 строка)

postgres=# show ignore_checksum_failure ;
 ignore_checksum_failure 
-------------------------
 on
(1 строка)

postgres=# \c test
Вы подключены к базе данных "test" как пользователь "postgres".
test=# select * from t1 ;
ПРЕДУПРЕЖДЕНИЕ:  ошибка проверки страницы: получена контрольная сумма 61016, а ожидалась - 45049
 id 
----
  1
  2
  4
  8
(4 строки)
```

Как видим, ошибка сохраняется, но данные выводятся.



