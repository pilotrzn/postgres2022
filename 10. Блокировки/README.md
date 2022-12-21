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

### Версия Postgres

```sql
postgres=# select version();
version
PostgreSQL 14.6 (Ubuntu 14.6-1.pgdg20.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, 64-bit
(1 строка)
```

### Параметры сервера в postgresql.conf

(добавлены параметры логирования, включен вывод только информации о блокировках):

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
log_line_prefix= '%t [%p]: [%l-1] '
log_lock_waits= 'on'
deadlock_timeout = '200ms'
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

## Моделирование ситуации с блокировками

Для проверки создадим таблицу в нашей тестовой базе testdb:

```sql
testdb=# create table testtable(id int, value numeric);
CREATE TABLE
testdb=# insert into testtable 
    VALUES (1,1000.00), (2,2000.00), (3,3000.00);
INSERT 0 3
testdb=# select * from testtable ;
 id |  value
----+---------
  1 | 1000.00
  2 | 2000.00
  3 | 3000.00
(3 строки)
```

Далее откроем 2 консоли, подключимся к серверу Postgres. С помощью инструмента MobaXterm можем сделать одновременный ввод в обеих консолях для моделирования ситуации блокировки.

Первая консоль:

```sql
testdb=# begin;
BEGIN
testdb=*# update testtable 
    set value=value-100 where id=1;
UPDATE 1
testdb=*#
```

Вторая консоль:

```sql
testdb=# begin;
BEGIN
testdb=*# update testtable 
    set value=value+100 where id=1;

```

в первой консоли делаем уменьшение значения, во второй увеличение. Во второй консоли видно, что транзакция в состоянии ожидания. В логе сервера наблюдаем запись:

```text
2022-12-20 21:26:53 MSK [2068]: [10-1] LOG:  process 2068 still waiting for ShareLock on transaction 80583862 after 201.338 ms
2022-12-20 21:26:53 MSK [2068]: [11-1] DETAIL:  Process holding the lock: 2067. Wait queue: 2068.
2022-12-20 21:26:53 MSK [2068]: [12-1] CONTEXT:  while updating tuple (0,1) in relation "testtable"
2022-12-20 21:26:53 MSK [2068]: [13-1] STATEMENT:  update testtable set value=value+100 where id=1;
```

В первой записи видно, что процесс 2068 ожидает состояния ShareLock в транзакции 80583862 спустя 201.338 мс.

## Моделирование ситуации с блокировками 3 транзакций

Для "красоты" вывода информации в базе создадим VIEW:

```sql
testdb=# CREATE VIEW locks_v AS
SELECT pid,
       locktype,
       CASE locktype
         WHEN 'relation' THEN relation::regclass::text
         WHEN 'transactionid' THEN transactionid::text
         WHEN 'tuple' THEN relation::regclass::text||':'||tuple::text
       END AS lockid,
       mode,
       granted
FROM pg_locks
WHERE locktype in ('relation','transactionid','tuple')
AND (locktype != 'relation' OR relation = 'accounts'::regclass);
```

 Откроем 3 консоли, подключимся к postgres и запустим транзакции. Выполнять будем так же, с помощью MobaXterm для одновременного ввода. Ниже общая картинка со всех консолей, где видны номера pid процесса и xid транзакции:

 ![locks_3_trans][1]

[1]: ../img/locks_3_transactions.png

Далее в каждой из консолей выполним одновременно команду на обновление:

```sql
testdb=*# update testtable 
    set value=value+100 where id=2;
UPDATE 1
```

После выполнения 2 из 3 консолей "повисли" в ожидании. Первой выполнилась команда процесса 2068. Ниже в логе видно, что процесс 2067 ожидает завершения транзакции процесса 2068. Процесс 3396 ожидает завершения ExclisiveLock строки, и так же ожидает завершения транзакции процесса 2067.

Лог сервера:

```text
2022-12-20 22:48:41 MSK [2067]: [1-1] LOG:  process 2067 still waiting for ShareLock on transaction 80583865 after 220.969 ms
2022-12-20 22:48:41 MSK [2067]: [2-1] DETAIL:  Process holding the lock: 2068. Wait queue: 2067.
2022-12-20 22:48:41 MSK [2067]: [3-1] CONTEXT:  while updating tuple (0,2) in relation "testtable"
2022-12-20 22:48:41 MSK [2067]: [4-1] STATEMENT:  update testtable set value = value +100 where id=2;
2022-12-20 22:48:41 MSK [3396]: [1-1] LOG:  process 3396 still waiting for ExclusiveLock on tuple (0,2) of relation 21842 of database 16384 after 221.330 ms
2022-12-20 22:48:41 MSK [3396]: [2-1] DETAIL:  Process holding the lock: 2067. Wait queue: 3396.
2022-12-20 22:48:41 MSK [3396]: [3-1] STATEMENT:  update testtable set value = value +100 where id=2;
```

Выполним запрос в VIEW по каждому из процессов:

```sql
testdb=*# SELECT * FROM locks_v 
            WHERE pid = 2068;
 pid  |   locktype    |  lockid  |     mode      | granted
------+---------------+----------+---------------+---------
 2068 | transactionid | 80583865 | ExclusiveLock | t
(1 строка)


testdb=*# SELECT * FROM locks_v 
            WHERE pid = 2067;
 pid  |   locktype    |   lockid    |     mode      | granted
------+---------------+-------------+---------------+---------
 2067 | transactionid | 80583865    | ShareLock     | f
 2067 | tuple         | testtable:2 | ExclusiveLock | t
 2067 | transactionid | 80583864    | ExclusiveLock | t
(3 строки)


testdb=*# SELECT * FROM locks_v 
            WHERE pid = 3396;
 pid  |   locktype    |   lockid    |     mode      | granted
------+---------------+-------------+---------------+---------
 3396 | tuple         | testtable:2 | ExclusiveLock | f
 3396 | transactionid | 80583863    | ExclusiveLock | t
(2 строки)
```

В первом запросе получаем информацию, что процесс 2068 выполняет блокировку уровня Exclusive(несовместимая ни с чем), из чего можно предположить, что пока эта транзакция не завершится, другие не смогут сделать ничего со строкой. В текущей ситуации транзакция блокирует изменяемую строку.

Во втором запросе видим, что транзакция процесса 2067, запустившаяся второй, ожидает возможности выполнить блокировку ShareLock.  То есть для дальнейшего выполнения транзакции требуется прочитать строку, но она заблокирована другой транзакцией. О чем сообщает  третья запись, что есть эксклюзивная блокировка от транзакции 80583864, во второй строке запись об эксклюзивной блокировке строки(tuple).

В третьем запросе процесс 3396 имеет 2 эксклюзивные блокировки, причем поле granted показывает, что заблокирована строка(tuple).

Далее завершаем первую транзакцию 2068. В консоли наблюдаю выполнение команды процесса 2067. Появилась запись, что процесс 3396 ожидает ShareLock, то есть ожидается завершение эксклюзивной блокировки для чтения строки.

Лог сервера:

```text
2022-12-20 23:17:58 MSK [2067]: [5-1] LOG:  process 2067 acquired ShareLock on transaction 80583865 after 1757800.470 ms
2022-12-20 23:17:58 MSK [2067]: [6-1] CONTEXT:  while updating tuple (0,2) in relation "testtable"
2022-12-20 23:17:58 MSK [2067]: [7-1] STATEMENT:  update testtable set value = value + 100 where id=2;
2022-12-20 23:17:58 MSK [3396]: [4-1] LOG:  process 3396 acquired ExclusiveLock on tuple (0,2) of relation 21842 of database 16384 after 1757800.894 ms
2022-12-20 23:17:58 MSK [3396]: [5-1] STATEMENT:  update testtable set value = value + 100 where id=2;
2022-12-20 23:17:59 MSK [3396]: [6-1] LOG:  process 3396 still waiting for ShareLock on transaction 80583864 after 207.637 ms
2022-12-20 23:17:59 MSK [3396]: [7-1] DETAIL:  Process holding the lock: 2067. Wait queue: 3396.
2022-12-20 23:17:59 MSK [3396]: [8-1] CONTEXT:  while rechecking updated tuple (0,6) in relation "testtable"
2022-12-20 23:17:59 MSK [3396]: [9-1] STATEMENT:  update testtable set value = value +100 where id=2;
```

Состояния блокировок поменялись:

```sql
testdb=# SELECT * FROM locks_v WHERE pid = 2067;
 pid  |   locktype    |  lockid  |     mode      | granted
------+---------------+----------+---------------+---------
 2067 | transactionid | 80583864 | ExclusiveLock | t
(1 строка)

testdb=# SELECT * FROM locks_v WHERE pid = 3396;
 pid  |   locktype    |  lockid  |     mode      | granted
------+---------------+----------+---------------+---------
 3396 | transactionid | 80583864 | ShareLock     | f
 3396 | transactionid | 80583863 | ExclusiveLock | t
(2 строки)
```

Теперь получается ситуация, которая была с первой и второй транзакцией - ожидается завершение эксклюзивной для выполнения чтения. Выполнив Commit второй транзакции, видим выполнение третьей. И остается одна блокировка третьей транзакции:

```sql
testdb=# SELECT * FROM locks_v WHERE pid = 3396;
 pid  |   locktype    |  lockid  |     mode      | granted
------+---------------+----------+---------------+---------
 3396 | transactionid | 80583863 | ExclusiveLock | t
(1 строка)
```

## Взаимоблокировка трех транзакций

Для начала зайдем заново в psql в каждой консоли, запустим трензакции и выполним UPDATE разных строк:

1 консоль:

```sql
testdb=# begin;
BEGIN
testdb=*# select pg_backend_pid(),txid_current();
 pg_backend_pid | txid_current
----------------+--------------
          23736 |     80583891
(1 строка)

testdb=*# update testtable set value=value+100 where id=1;
UPDATE 1
```

2 консоль:

```sql
testdb=# begin;
BEGIN
testdb=*# select pg_backend_pid(),txid_current();
 pg_backend_pid | txid_current
----------------+--------------
          23735 |     80583889
(1 строка)

testdb=*# update testtable set value=value+30 where id=2;
UPDATE 1
```

3 консоль:

```sql
testdb=# begin;
BEGIN
testdb=*# select pg_backend_pid(),txid_current();
 pg_backend_pid | txid_current
----------------+--------------
          23734 |     80583890
(1 строка)

testdb=*# update testtable set value=value+10 where id=3;
UPDATE 1
```

Как видим, каждая из транзакций выполняет обновление своей строки, не пересекается с другими транзакциями и ожидает дальнейших команд.
В 1 консоли попробуем выполнить обновление с id=3(из консоли 3):

```sql
testdb=*# update testtable set value=value+5 where id=3;
```

Транзакция повисает в ожидании и в логе сервера появляется запись:

```text
2022-12-21 18:25:13 MSK [23736]: LOG:  process 23736 still waiting for ShareLock on transaction 80583890 after 208.206 ms
2022-12-21 18:25:13 MSK [23736]: DETAIL:  Process holding the lock: 23734. Wait queue: 23736.
2022-12-21 18:25:13 MSK [23736]: CONTEXT:  while updating tuple (0,21) in relation "testtable"
2022-12-21 18:25:13 MSK [23736]: STATEMENT:  update testtable set value=value+5 where id=3;
```

Тут явно прописано, что есть процесс, удерживающий блокировку - 23734, и ожидающий - 23736. Далее идут детали, - какую версию ожидает и какая команда введена.
В консоли 2 выполним обновление строки с id=1(из консоли 1):

```sql
testdb=*# update testtable set value=value+30 where id=1;
```

Транзакция повисает, и в логе сервера появляется запись:

```text
2022-12-21 18:26:43 MSK [23735]: LOG:  process 23735 still waiting for ShareLock on transaction 80583891 after 201.900 ms
2022-12-21 18:26:43 MSK [23735]: DETAIL:  Process holding the lock: 23736. Wait queue: 23735.
2022-12-21 18:26:43 MSK [23735]: CONTEXT:  while updating tuple (0,20) in relation "testtable"
2022-12-21 18:26:43 MSK [23735]: STATEMENT:  update testtable set value=value+30 where id=1;
```

Запись говорит о том, что есть процесс удерживающий запись - 23736, и ожидающий - 23735.

Теперь в 3 консоли попытаемя обновить запись с id=2:

```sql
testdb=*# update testtable set value=value+150 where id=2;
ERROR:  deadlock detected
ПОДРОБНОСТИ:  Process 23734 waits for ShareLock on transaction 80583889; blocked by process 23735.
Process 23735 waits for ShareLock on transaction 80583891; blocked by process 23736.
Process 23736 waits for ShareLock on transaction 80583890; blocked by process 23734.
ПОДСКАЗКА:  See server log for query details.
КОНТЕКСТ:  while updating tuple (0,22) in relation "testtable"
```

Тут же в консоли получаем сообщение что обнаружен deadlock, указаны номера транзакций, участвующих в блокировке. В логе так же присутствует сообщение:

```text
2022-12-21 18:27:31 MSK [23734]: LOG:  process 23734 detected deadlock while waiting for ShareLock on transaction 80583889 after 201.053 ms
2022-12-21 18:27:31 MSK [23734]: DETAIL:  Process holding the lock: 23735. Wait queue: .
2022-12-21 18:27:31 MSK [23734]: CONTEXT:  while updating tuple (0,22) in relation "testtable"
2022-12-21 18:27:31 MSK [23734]: STATEMENT:  update testtable set value=value+150 where id=2;
2022-12-21 18:27:31 MSK [23734]: ERROR:  deadlock detected
2022-12-21 18:27:31 MSK [23734]: DETAIL:  Process 23734 waits for ShareLock on transaction 80583889; blocked by process 23735.
        Process 23735 waits for ShareLock on transaction 80583891; blocked by process 23736.
        Process 23736 waits for ShareLock on transaction 80583890; blocked by process 23734.
        Process 23734: update testtable set value=value+150 where id=2;
        Process 23735: update testtable set value=value+30 where id=1;
        Process 23736: update testtable set value=value+5 where id=3;
2022-12-21 18:27:31 MSK [23734]: HINT:  See server log for query details.
2022-12-21 18:27:31 MSK [23734]: CONTEXT:  while updating tuple (0,22) in relation "testtable"
2022-12-21 18:27:31 MSK [23734]: STATEMENT:  update testtable set value=value+150 where id=2;
2022-12-21 18:27:31 MSK [23736]: LOG:  process 23736 acquired ShareLock on transaction 80583890 after 138135.276 ms
2022-12-21 18:27:31 MSK [23736]: CONTEXT:  while updating tuple (0,21) in relation "testtable"
2022-12-21 18:27:31 MSK [23736]: STATEMENT:  update testtable set value=value+5 where id=3;
```

Проанализировав лог, можно выяснить какие процессы участвуют в блокировке и какие команды выполнялись. Зная id процессов, можно найти источник с помощью представления pg_stat_activity.

Теперь завершим транзакцию в первой консоли, выполнив commit. Во второй консоли в этот момент выполнится обновление строки с id=1. Запись в логе:

```text
2022-12-21 18:54:22 MSK [23735]: LOG:  process 23735 acquired ShareLock on transaction 80583891 after 1658995.520 ms
2022-12-21 18:54:22 MSK [23735]: CONTEXT:  while updating tuple (0,20) in relation "testtable"
2022-12-21 18:54:22 MSK [23735]: STATEMENT:  update testtable set value=value+30 where id=1;
```

говорит о том, что процесс 23735(2 консоль) получил ShareLock и может выполнить обновление. Завершим транзакцию во второй консоли. Остается открытой только третья консоль. Выполним Commit. Получим сообщение об откате транзакции.

```sql
testdb=!# commit;
ROLLBACK
testdb=# select * from testtable;
 id | value
----+-------
  2 |    30
  3 |     5
  1 |   130
(3 строки)
```

Выполним SELECT  из нашей таблицы и увидим что строка с id 3 была обновлена значением 5, что выполнялось в консоли 1, а изменение консоли 3 не применилось так как был выполнен откат.

Из проделанного эксперимента могу сделать вывод, что взаимоблокировка 3 транзакций возможна, при этом 2 и 3 транзакций могут быть выполнены.


## Блокировка целой таблицы

Задача выполнить 2 транзакции, выполняющие UPDATE всей таблицы без фильтра WHERE.
Попробовав выполнить такой вариант, когда в одной транзакции ввожу "update testtable set value=value+100;" и потом подобный UPDATE во второй транзакции получил зависание второй транзакции. Выполнив запрос к нашему представлению locks_v в первой транзакции, получил информацию что процесс держит EXclusiveLock, что не позволяет выполнять другую транзакцию, пока не завершится блокирующая. Таким образом получается, что невозможно добиться взаимоблокировки двух транзакций, выполняющих полный UPDATE таблицы. Надеюсь, что не ошибся в выводе.
