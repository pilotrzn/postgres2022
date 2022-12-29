create database otus;


--немного о json
select * from pg_settings;
create table pg_settings_json as select jsonb_build_object('name',name,'setting',setting,'category',category) as data from pg_settings;
select * from pg_settings_json;

set enable_seqscan='on';
explain
select * from pg_settings_json where "data" ->> 'name' = 'max_connections';

create index pg_settings_json_idx_btree on pg_settings_json (("data" ->> 'name'));
drop index pg_settings_json_idx_btree;

create index pg_settings_json_idx_hash on pg_settings_json using hash(("data" ->> 'name'));
drop index pg_settings_json_idx_hash;

create EXTENSION pg_trgm;
create index pg_settings_json_idx_gin on pg_settings_json using gin(("data" ->> 'name'));  gin_trgm_ops
drop index pg_settings_json_idx_gin;

drop table if exists pg_settings_json;

--Nested loop и товарищи
select * from pg_class;
select * from pg_attribute;



--nested loop в зависимости от настроек (analyse гляунть что планировщик ошибается)
set enable_seqscan='on';

explain analyse
select *
    from pg_class c
        join pg_attribute a on c.oid = a.attrelid  where c.relname in ( 'pg_class', 'pg_namespace');
--'pg_config','pg_statistic'

--Смотрим как меняется использование памяти
explain analyse
select a.attrelid
    from pg_class c
        join pg_attribute a on c.oid = a.attrelid;

explain analyse
select *
    from pg_class c
        join pg_attribute a on c.oid = a.attrelid ;


--Использование темповых файлов
SET work_mem = '64kB';
reset work_mem;
SET enable_hashjoin = on;
SET enable_mergejoin = on;
SET enable_nestloop = on;
SET log_temp_files = 0;
explain (analyse,buffers)
select *
    from pg_class c
        join pg_attribute a on c.oid = a.attrelid ;
reset work_mem;
reset log_temp_files;
SET enable_hashjoin = on;
SET enable_mergejoin = on;
SET enable_nestloop = on;


--Непосредствеено соединения

create table bus (id serial,route text,id_model int);
create table model_bus (id serial,name text);;
insert into bus values (1,'Москва-Болшево',1),(2,'Москва-Пушкино',1),(3,'Москва-Ярославль',2),(4,'Москва-Кострома',2),(5,'Москва-Волгорад',3),
                       (6,'Москва-Иваново',null),(7,'Москва-Саратов',null),(8,'Москва-Воронеж',null);
insert into model_bus values(1,'ПАЗ'),(2,'ЛИАЗ'),(3,'MAN'),(4,'МАЗ'),(5,'НЕФАЗ'),(6,'ЗиС'),(7,'Икарус');


select * from bus;
select * from model_bus;

-- Прямое соединениие
--explain
select *
from bus b
join model_bus mb
    on b.id_model=mb.id;

explain
select *
from bus b,model_bus mb
where b.id_model=mb.id;

--left join
explain
select *
from bus b
left join model_bus mb
    on b.id_model=mb.id;

--right join
explain
select *
from bus b
right join model_bus mb
    on b.id_model=mb.id;

--left with null
explain
select *
from bus b
left join model_bus mb on b.id_model=mb.id
where mb.id is null;

--right with null
select *
from bus b
right join model_bus mb on b.id_model=mb.id
where b.id
    is null;


--full join
select *
from bus b
full join model_bus mb on b.id_model=mb.id;

select *
from bus b
full join model_bus mb on b.id_model=mb.id
where b.id is null or mb.id is null;


--cross join
explain
select *
from bus b
cross join model_bus mb;

explain --(join)
select *
from bus b
cross join model_bus mb
where  b.id_model=mb.id;

select *
from bus b,model_bus mb;
--where 1=1;

----test
create table a (id integer);
create table b (id integer);

insert into a values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1);
insert into b values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1);

insert into a values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
insert into b values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

select *
from a
    join b on a.id=b.id;

drop table a;
drop table b;


--lateral join

drop table t_product;
CREATE TABLE t_product AS
    SELECT   id AS product_id,
             id * 10 * random() AS price,
             'product ' || id AS product
    FROM generate_series(1, 1000) AS id;

drop table t_wishlist;
CREATE TABLE t_wishlist
(
    wishlist_id        int,
    username           text,
    desired_price      numeric
);

INSERT INTO t_wishlist VALUES
    (1, 'hans', '450'),
    (2, 'joe', '60'),
    (3, 'jane', '1500');

SELECT * FROM t_product LIMIT 10;
SELECT * FROM t_wishlist;

explain
SELECT        *
FROM      t_wishlist AS w
    left join LATERAL  (SELECT      *
        FROM       t_product AS p
        WHERE       p.price < w.desired_price
        ORDER BY p.price DESC
        LIMIT 5
       ) AS x
on true
ORDER BY wishlist_id, price DESC;

explain
SELECT        *
FROM      t_wishlist AS w,
    LATERAL  (SELECT      *
        FROM       t_product AS p
        WHERE       p.price < w.desired_price
        ORDER BY p.price DESC
        LIMIT 5
       ) AS x
ORDER BY wishlist_id, price DESC;


---Пример lateral join  с погодой
drop table if exists temperature;
drop table if exists humidity;

CREATE TABLE temperature(
  ts TIMESTAMP NOT NULL,
  city TEXT NOT NULL,
  temperature INT NOT NULL);

CREATE TABLE humidity(
  ts TIMESTAMP NOT NULL,
  city TEXT NOT NULL,
  humidity INT NOT NULL);

INSERT INTO temperature (ts, city, temperature)
SELECT ts + (INTERVAL '60 minutes' * random()), city, 30*random()
FROM generate_series('2022-01-01' :: TIMESTAMP,
                     '2022-01-31', '1 day') AS ts,
     unnest(array['Moscow', 'Berlin','Volgograd']) AS city;

INSERT INTO humidity (ts, city, humidity)
SELECT ts + (INTERVAL '60 minutes' * random()), city, 100*random()
FROM generate_series('2022-01-01' :: TIMESTAMP,
                     '2022-01-31', '1 day') AS ts,
     unnest(array['Moscow', 'Berlin','Volgograd']) AS city;

select * from temperature;
select * from humidity;

SELECT t.ts, t.city, t.temperature, h.humidity
FROM temperature AS t
LEFT JOIN humidity AS h ON t.ts = h.ts;

SELECT t.ts, t.city, t.temperature, h.humidity
FROM temperature AS t
LEFT JOIN LATERAL
  ( SELECT * FROM humidity
    WHERE city = t.city AND ts <= t.ts
    ORDER BY ts DESC LIMIT 1
  ) AS h ON TRUE
WHERE t.ts < '2022-01-5';

SELECT * FROM temperature WHERE ts < '2022-01-05' ORDER BY ts, city;
SELECT * FROM humidity WHERE ts < '2022-01-05' ORDER BY ts, city;


--Порядок join (параметры планировщика)
drop table test_1000;
CREATE TABLE test_1000 AS
    SELECT    (random()*100)::int AS id,
             'product ' || id AS product
    FROM generate_series(1, 10000) AS id;

select * from test_1000;

drop table test_1;
create table test_1 (id int);
insert into test_1 values (1);

select * from test_1;

SET enable_hashjoin = off;
SET enable_mergejoin = off;
SET enable_nestloop = on;


set join_collapse_limit to 8;    set join_collapse_limit to 1;

explain
select *
from test_1 t1
inner join test_1000 t1000
on t1000.id=t1.id
inner join test_1 t1_2
on t1_2.id=t1000.id;

--Union intersect except

DROP TABLE IF EXISTS top_rated_films;
CREATE TABLE top_rated_films(
	title VARCHAR NOT NULL,
	release_year SMALLINT
);

DROP TABLE IF EXISTS most_popular_films;
CREATE TABLE most_popular_films(
	title VARCHAR NOT NULL,
	release_year SMALLINT
);

INSERT INTO
   top_rated_films(title,release_year)
VALUES
   ('The Shawshank Redemption',1994),
   ('The Godfather',1972),
   ('12 Angry Men',1957);

INSERT INTO
   most_popular_films(title,release_year)
VALUES
   ('An American Pickle',2020),
   ('The Godfather',1972),
   ('Greyhound',2020);

SELECT * FROM top_rated_films;
select * from most_popular_films;

SELECT * FROM top_rated_films
UNION ALL
SELECT * FROM most_popular_films;

SELECT * FROM top_rated_films
UNION all
SELECT * FROM most_popular_films;

SELECT * FROM top_rated_films
INTERSECT
SELECT * FROM most_popular_films;

SELECT * FROM top_rated_films
EXCEPT
SELECT * FROM most_popular_films;


SELECT * FROM  most_popular_films
EXCEPT
SELECT * FROM top_rated_films;


SELECT
  i.relname AS index_for_cluster,idx.indisclustered
FROM
  pg_index AS idx
JOIN
  pg_class AS i
ON
  i.oid = idx.indexrelid
WHERE
  idx.indisclustered
  AND idx.indrelid::regclass = 'orders'::regclass;

