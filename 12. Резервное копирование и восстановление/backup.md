sudo pg_ctlcluster 12 main start

##переход в постгрес
sudo -u postgres psql
sudo -u postgres psql -p 5432

create database otus;
\c otus

create table student as 
select 
  generate_series(1,10) as id,
  md5(random()::text)::char(10) as fio;


\copy student to '/mnt/d/2/st.sql';

\help copy

\copy student from '/mnt/d/2/st.sql';


\copy student  to '/mnt/d/2/st.csv' with delimiter ',' ;

\copy student  from '/mnt/d/2/st.csv' with delimiter ',' ; 

----pg_dump

pg_dump -d otus -C -U postgres > /mnt/d/2/arh2.sql 

psql -U postgres  otus < /mnt/d/2/arh2.sql 

pg_dump -p 5432 -d otus -U postgres | psql -p 5433 -U postgres otus

---
##архив
pg_dump -d otus --create -U postgres -Fc > /mnt/d/2/arh2.gz 

echo "DROP DATABASE otus;" | psql -U postgres
echo "CREATE DATABASE otus;" | psql -U postgres

pg_restore -d otus -U postgres /mnt/d/2/arh2.gz

----- pg_dumpall 
pg_dumpall -U postgres > /mnt/d/2/bkup_all.sql
psql -U postgres < /mnt/d/2/bkup_all.sql


---------
ALTER SYSTEM SET wal_level = logical;

### Рестартуем кластер
sudo pg_ctlcluster 12 main restart

pg_createcluster -d /var/lib/postgresql/12/main2 12 main2

rm -rf /var/lib/postgresql/12/main2

pg_basebackup -p 5432 -D /var/lib/postgresql/12/main2

echo 'port = 5434' | tee –append /var/lib/postgresql/12/main2/postgresql.auto.conf

pg_ctlcluster 12 main2 start

pg_lsclusters

###Удаление кластера
pg_dropcluster 12 main2


----
SELECT name, setting FROM pg_settings WHERE name IN ('archive_mode','archive_command','archive_timeout');

