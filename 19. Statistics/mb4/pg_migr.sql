CREATE TABLE mb.models (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	sfid varchar(50) NULL,
	modelname varchar(50) NULL,
	description varchar(100) null,
	constraint models_id primary key (id)
);

CREATE TABLE mb.analyses (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	model_id int not null,
	analyse_name varchar NULL,
	description varchar NULL,
	type int4 NOT NULL,
	sort_index int4 null,
	sfid varchar NOT NULL
);
alter table mb.analyses add constraint fk__analyses_modelid foreign key (model_id) references mb.models(id); 


insert into mb.analyses (model_id,sfid,analyse_name,description, "type",sort_index)
select 
 m.id ,
 a."SfId" ,
 a."Name" 
 ,a."Description" 
 ,a."Type" 
 ,a."SortIndex" 
from  public."Analyses" a 
inner join mb.models m 
on m.sfid = a."ModelSfId" ;

CREATE TABLE mb.cases (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    case_id int4 NOT NULL,
	prev_case_id int4 NULL,
	analyses_id int4 not null,
	starttime timestamp NOT NULL,
	endtime timestamp NOT NULL,
	sfid varchar NOT null,
	constraint cases_id primary key(id)
);
alter table mb.cases add constraint fk__cases_analysesid foreign key (analyses_id) references mb.analyses(id);

insert into mb.cases(case_id,prev_case_id,analyses_id,starttime,endtime,sfid)
select c.id 
,c.prevcaseid 
,a.id 
,c.starttime 
,c.endtime 
,c.sfid 
from public.cases c 
inner join mb.analyses a 
on c.analysissfid  =a.sfid; 