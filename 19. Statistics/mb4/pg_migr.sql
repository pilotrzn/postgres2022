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
alter table mb.cases add constraint pk_case_id unique (case_id);

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

CREATE TABLE mb.object_types (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,	
	type_id int8 NOT NULL,
	code_name varchar NOT NULL,
	mame varchar NOT NULL)
	;
alter table mb.object_types  add constraint pk_type_id unique (type_id);

CREATE TABLE mb.objects (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	object_type_id int8 NOT NULL,
	model_id int4 NOT NULL,
	parent_id int4 NULL,
	is_deleted int2 NOT NULL,
	is_visible int2 NOT NULL,
	create_case_id int4 NULL,
	delete_case_id int4 NULL,
	object_name varchar NULL,
	old_Id int4 NOT null,
	constraint object_id primary key (id)
);
alter table mb.objects add constraint fk__oblects_objecttypes foreign key (object_type_id) references mb.object_types(type_id);
alter table mb.objects add constraint fk__oblects_modelid foreign key (model_id) references mb.models(id);
alter table mb.objects add constraint fk__oblects_create_caseid foreign key (create_case_id) references mb.cases(case_id);
alter table mb.objects add constraint fk__oblects_delete_caseid foreign key (delete_case_id) references mb.cases(case_id);


insert into mb.objects (object_type_id,model_id,parent_id, is_deleted,is_visible,create_case_id, delete_case_id, object_name, old_id)
select 
o."ObjectTypeId" ,
m.id ,
o."ParentId" ,
o."IsDeleted" ,
o."IsVisible" ,
o."CreateCaseId" ,
case when o."DeleteCaseId"=-1 then null else o."DeleteCaseId" end  ,
o."Name", 
o."Id" 
from public."Objects" o 
left join mb.models m 
on m.sfid = o."ModelSfId" ;

CREATE TABLE mb.products (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,		
	product_id int4 not null,
	product_name varchar(250) NULL,
	group_id int4 NULL,
	is_deleted int2 NULL,
	create_case_id int4 NULL,
	delete_case_id int4 null,
	constraint prod_id primary key(id),
	constraint pk_product_id unique(product_id)
);
alter table mb.products add constraint fk__products_create_caseid foreign key (create_case_id) references mb.cases(case_id);
alter table mb.products add constraint fk__products_delete_caseid foreign key (delete_case_id) references mb.cases(case_id);

insert into mb.products (product_id,product_name,group_id,is_deleted,create_case_id,delete_case_id)
SELECT productid, "name" , groupid , isdeleted,case when createcaseid =-1 then null else createcaseid end, deletecaseid
FROM public.products;

CREATE TABLE mb.material (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,		
	product_id int4 not null,
	sapcode varchar(20) NULL,
	sorting_index int4 null,
	product_name varchar(250) NULL,
	material_group varchar(250) NULL,
	material_category varchar(250) NULL,
	report_category varchar(250) NULL,
	report_category_type varchar(250) NULL,
	constraint material_id primary key (id)	
);
alter table mb.material add constraint fk__material_product_id foreign key(product_id) references mb.products(product_id);

INSERT INTO mb.material
(product_id, sapcode, sorting_index, product_name, material_group, material_category, report_category, report_category_type)
SELECT p.product_id , sapcode, sorting_index , "name" , material_group, material_category, report_category, report_categorytype
FROM public.material m
inner join mb.products p 
on p.product_name = m."name" ;

CREATE TABLE mb.flows (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	flow_id int4 NULL,
	meter_id int4 NULL,
	source_id int4 NULL,
	dest_id int4 NULL,
	product_id int4 NULL,
	secondproduct_id int4 null,
	constraint flow_id primary key(id),
	constraint pk_flows_id unique (flow_id)
);
alter table mb.flows add constraint fk__flows_source_id foreign key (source_id) references mb.objects(id);
alter table mb.flows add constraint fk__flows_dest_id foreign key (dest_id) references mb.objects(id);
alter table mb.flows add constraint fk__flows_meter_id foreign key (meter_id) references mb.objects(id);


INSERT INTO mb.flows
(flow_id, meter_id, source_id, dest_id, product_id, secondproduct_id)
SELECT f.id, meters.id ,src.id, dst.id , productid,  secondproductid
FROM public.flows f
left join mb.objects src on src.old_id = f.sourceid 
left join mb.objects dst on dst.old_id = f.destid 
left join mb.objects meters on meters.old_id = f.meterid ;


CREATE TABLE mb.flowsvar (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	flowsvar_id int4 NULL,
	case_id int4 NULL,
	product_id int4 NULL,
	second_product_id int4 NULL,
	reconciled int4 NULL,
	object_status char(2) NULL,
	technoupperbound float8 NULL,
	technolowerbound float8 NULL,
	reconciledabstolerance float8 null,
	constraint flowsvar_id primary key(id),
	constraint pk_flowsvar_id unique(flowsvar_id)
);
alter table mb.flowsvar add constraint fk__flowsvarid_object_id foreign key (flowsvar_id) references mb.objects(id);
alter table mb.flowsvar add constraint fk__product_id_product_id foreign key (product_id) references mb.products(product_id);
alter table mb.flowsvar add constraint fk__second_product_id_product_id foreign key (second_product_id) references mb.products(id);