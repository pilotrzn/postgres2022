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
checkpoint_timeout = '15min'
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
log_checkpoints = 'off'
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
log_lock_waits= 'on'
deadlock_timeout = 200ms
log_min_duration_statement= '-1'
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