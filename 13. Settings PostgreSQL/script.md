***
## shared_buffers
***
Используется для кэширования данных. По умолчанию низкое значение (для поддержки как можно большего кол-ва ОС). Начать стоит с его изменения. Согласно документации, рекомендуемое значение для данного параметра - 25% от общей оперативной памяти на сервере. PostgreSQL использует 2 кэша - свой (изменяется **shared_buffers**) и ОС. Редко значение больше, чем 40% окажет влияние на производительность.
***
## max_connections
***
Максимальное количество соединений. Для изменения данного параметра придётся перезапускать сервер. Если планируется использование PostgreSQL как DWH, то большое количество соединений не нужно. Данный параметр тесно связан с **work_mem**. Поэтому будьте пределено аккуратны с ним
***
## effective_cache_size
***
Служит подсказкой для планировщика, сколько ОП у него в запасе. Можно определить как **shared_buffers** + ОП системы - ОП используемое самой ОС и другими приложениями. За счёт данного параметра планировщик может чаще использовать индексы, строить hash таблицы. Наиболее часто используемое значение 75% ОП от общей на сервере.

Определяет представление планировщика об эффективном размере дискового кеша, доступном для одного запроса. Это представление влияет на оценку стоимости использования индекса; чем выше это значение, тем больше вероятность, что будет применяться сканирование по индексу, чем ниже, тем более вероятно, что будет выбрано последовательное сканирование. При установке этого параметра следует учитывать и объём разделяемых буферов PostgreSQL, и процент дискового кеша ядра, который будут занимать файлы данных PostgreSQL, хотя некоторые данные могут оказаться и там, и там. Кроме того, следует принять во внимание ожидаемое число параллельных запросов к разным таблицам, так как общий размер будет разделяться между ними. Этот параметр не влияет на размер разделяемой памяти, выделяемой PostgreSQL, и не задаёт размер резервируемого в ядре дискового кеша; он используется только в качестве ориентировочной оценки. При этом система не учитывает, что данные могут оставаться в дисковом кеше от запроса к запросу. Если это значение задаётся без единиц измерения, оно считается заданным в блоках (размер которых равен BLCKSZ байт, обычно это 8 КБ). Значение по умолчанию — 4 гигабайта (4GB). Если BLCKSZ отличен от 8 КБ, значение по умолчанию корректируется пропорционально. 
***

### random_page_cost
***
Задаёт приблизительную стоимость чтения одной произвольной страницы с диска. Значение по умолчанию равно 4.0. Это значение можно переопределить для таблиц и индексов в определённом табличном пространстве, установив одноимённый параметр табличного пространства (см. ALTER TABLESPACE).

При уменьшении этого значения по отношению к seq_page_cost система начинает предпочитать сканирование по индексу; при увеличении такое сканирование становится более дорогостоящим. Оба эти значения также можно увеличить или уменьшить одновременно, чтобы изменить стоимость операций ввода/вывода по отношению к стоимости процессорных операций, которая определяется следующими параметрами.

Произвольный доступ к механическому дисковому хранилищу обычно гораздо дороже последовательного доступа, более чем в четыре раза. Однако по умолчанию выбран небольшой коэффициент (4.0), в предположении, что большой объём данных при произвольном доступе, например, при чтении индекса, окажется в кеше. Таким образом, можно считать, что значение по умолчанию моделирует ситуацию, когда произвольный доступ в 40 раз медленнее последовательного, но 90% операций произвольного чтения удовлетворяются из кеша.

Если вы считаете, что для вашей рабочей нагрузки процент попаданий не достигает 90%, вы можете увеличить параметр random_page_cost, чтобы он больше соответствовал реальной стоимости произвольного чтения. И напротив, если ваши данные могут полностью поместиться в кеше, например, когда размер базы меньше общего объёма памяти сервера, может иметь смысл уменьшить random_page_cost. С хранилищем, у которого стоимость произвольного чтения не намного выше последовательного, как например, у твердотельных накопителей, так же лучше выбрать меньшее значение random_page_cost, например 1.1.
***

## work_mem
***
Используется для сортировок, построения hash таблиц. Это позволяет выполнять данные операции в памяти, что гораздо быстрее обращения к диску. В рамках одного запроса данный параметр может быть использован множество раз. Если ваш запрос содержит 5 операций сортировки, то память, которая потребуется для его выполнения уже как минимум **work_mem** * 5. Т.к. скорее-всего на сервере вы не одни и сессий много, то каждая из них может использовать этот параметр по нескольку раз, поэтому не рекомендуется делать его слишком большим. Можно выставить небольшое значение для глобального параметра в конфиге и потом, в случае сложных запросов, менять этот параметр локально (для текущей сессии)
Сущестуют различные варианты определения этого параметра в качестве начального:
Total RAM * 0.25 / max_connections
work_mem = RAM/32..64

***
## maintenance_work_mem
***
Определяет максимальное количество ОП для операций типа VACUUM, CREATE INDEX, CREATE FOREIGN KEY. Увеличение этого параметра позволит быстрее выполнять эти операции. Не связано с **work_mem** поэтому можно ставить в разы больше, чем **work_mem**
***
## wal_buffers
***
Объём разделяемой памяти, который будет использоваться для буферизации данных WAL, ещё не записанных на диск. Если у вас большое количество одновременных подключений, увеличение параметра улучшит производительность. По умолчанию -1, определяется автоматически, как 1/32 от **shared_buffers**, но не больше, чем 16 МБ (в ручную можно задавать большие значения). Обычно ставят 16 МБ
***
## max_wal_size
***
Максимальный размер, до которого может вырастать WAL между автоматическими контрольными точками в WAL. Значение по умолчанию — 1 ГБ. Увеличение этого параметра может привести к увеличению времени, которое потребуется для восстановления после сбоя, но позволяет реже выполнять операцию сбрасывания на диск. Так же сбрасывание может выполниться и при достижении нужного времени, определённого параметром **checkpoint_timeout**
***
## checkpoint_timeout
***
Чем реже происходит сбрасывание, тем дольше будет восстановление БД после сбоя. Значение по умолчанию 5 минут, рекомендуемое - от 30 минут до часа. 
***
Необходимо "синхронизировать" два этих параметра. Для этого можно поставить **checkpoint_timeout** в выбранный промежуток, включить параметр **log_checkpoints** и по нему отследить, сколько было записано буферов. После чего подогнать параметр **max_wal_size**

## effective_io_concurrency
Допустимое число одновременных операций ввода/вывода. Для жестких дисков указывается по количеству шпинделей, для массивов RAID5/6 следует исключить диски четности. Для SATA SSD это значение рекомендуется указывать равным 200, а для быстрых NVMe дисков его можно увеличить до 500-1000. При этом следует понимать, что высокие значения в сочетании с медленными дисками сделают обратный эффект.

***
# Полезные ссылки
1. https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server
2. https://info.crunchydata.com/blog/optimize-postgresql-server-performance
3. https://postgresqlco.nf/ru/doc/param/
4. https://www.2ndquadrant.com/en/blog/basics-of-tuning-checkpoints/
5. https://github.com/jfcoz/postgresqltuner