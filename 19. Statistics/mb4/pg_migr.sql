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
	sfid varchar NOT NULL,
	constraint fk__analyses_modelid foreign key (model_id) references mb.models(id)
);


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
	mame varchar NOT NULL,
	constraint pk_type_id unique (type_id)
	);

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
	constraint fk__products_create_caseid foreign key (create_case_id) references mb.cases(case_id),
	constraint fk__products_delete_caseid foreign key (delete_case_id) references mb.cases(case_id)
);

insert into mb.products (product_id,product_name,group_id,is_deleted,create_case_id,delete_case_id)
SELECT id, "name" , groupid , isdeleted,case when createcaseid =-1 then null else createcaseid end, deletecaseid
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
	constraint material_id primary key (id)	,
	constraint fk__material_product_id foreign key(product_id) references mb.products(product_id)
);

INSERT INTO mb.material
(product_id, sapcode, sorting_index, product_name, material_group, material_category, report_category, report_category_type)
SELECT p.id , sapcode, sorting_index , "name" , material_group, material_category, report_category, report_categorytype
FROM public.material m
inner join mb.products p 
on p.product_name = m."name" and p.delete_case_id  is null;

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
alter table mb.flows add constraint fk__flows_flow_id foreign key (flow_id) references mb.objects(id);

TRUNCATE TABLE mb.flows RESTART IDENTITY RESTRICT;

INSERT INTO mb.flows
(flow_id, meter_id, source_id, dest_id, product_id, secondproduct_id)
SELECT fl_id.id newflowid, meters.id meterid ,src.id sourceid, dst.id destid, productid,  secondproductid
FROM public.flows f
left join mb.objects fl_id on fl_id.old_Id = f.id
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
	constraint fk__flowsvar_case_id__cases_id foreign key (case_id) references mb.cases(case_id),
	constraint fk__flowsvar_id__object_id foreign key (flowsvar_id) references mb.objects(id),
	constraint fk__product_id__product_id foreign key (product_id) references mb.products(id),
	constraint fk__second_product_id__product_id foreign key (second_product_id) references mb.products(id)
	);

INSERT INTO mb.flowsvar
(flowsvar_id , case_id, product_id, second_product_id, reconciled, object_status, technoupperbound, technolowerbound, reconciledabstolerance)
select fvobj.id, caseid, fv.productid  ,fv.secondproductid  , reconciled, objectstatus, technoupperbound, technolowerbound, reconciledabstolerance
FROM public.flowsvar fv
left join mb.objects fvobj on fvobj.old_id = fv.id; 


CREATE TABLE mb.flowsmeters (
	id int4 NULL,
	flow_id int4 NULL,
	meter_id int4 null,
	constraint fk__fm_id_object_id foreign key (id) references mb.objects(id),
	constraint fk__fm_flow_id_object_id foreign key (id) references mb.objects(id),
	constraint fk__fm_meter_id_object_id foreign key (id) references mb.objects(id)
);

INSERT INTO mb.flowsmeters
(id, flow_id, meter_id)
SELECT objid.id, flowobj.id, metobj.id  
FROM public.flowsmeters fm
left join mb.objects objid on objid.old_id = fm.id
left join mb.objects flowobj on flowobj.old_id = fm.flowid 
left join mb.objects metobj on metobj.old_id = fm.meterid 
;

drop table mb.metersvar ;
CREATE TABLE mb.metersvar (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	meter_id int4 not NULL,
	case_id int4 NULL,
	measured float8 not null default 0,
	tolerance float8 not null default 0,
	abs_tolerance float8  null ,
	metro_upper_bound float8 null ,
	metro_lower_bound float8 null ,	
	techno_lower_bound float8  null,
	techno_upper_bound float8 null ,
	measured_mass_ssot float8 null ,
	measured_mass_loss float8 null,
	loss_norm float8 null ,
	object_status char(2) null,
	constraint pk_metersvar_id primary key (id),
	constraint fk__meters_meter_id__object_id foreign key (meter_id) references mb.objects(id),
	constraint fk__meters_case_id__cases_id foreign key (case_id) references mb.cases(case_id)
);

INSERT INTO mb.metersvar
(meter_id, case_id, measured, tolerance, abs_tolerance, metro_upper_bound, metro_lower_bound, techno_lower_bound, techno_upper_bound, measured_mass_ssot, measured_mass_loss, loss_norm, object_status)
SELECT o.id, caseid, measured, coalesce(tolerance,0), abstolerance, metroupperbound, metrolowerbound, technolowerbound, technoupperbound, measuredmassssot, coalesce(measuredmassloss,0), coalesce(lossnorm,0),  objectstatus
FROM public.metersvar mv
left join mb.objects o  on o.old_id = mv.id ;


CREATE TABLE mb.transactions (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	transaction_id int4 not null,
	case_id int4 NOT NULL,
	source_id int4 NOT NULL,
	dest_id int4 NOT NULL,
	product_id int4 NULL,
	second_product_id int4 NULL,
	measured float8 NOT null default 0,
	reconciled float8 NOT null default 0,
	tolerance float8 NOT null default 0,
	abs_tolerance float8 NULL,
	techno_upper_bound float8 NULL,
	techno_lower_bound float8 NULL,
	metro_lower_bound float8 NOT NULL,
	metro_upper_bound float8 NOT NULL,
	object_status char(2) null,
	constraint pk__transactions_id primary key (id),
	constraint fk__transactions_case_id__cases_case_id       foreign key (case_id) references mb.cases(case_id), 
	constraint fk__transactions_transaction_id__object_id 	 foreign key (transaction_id) references mb.objects(id),
	constraint fk__transactions_source_id__object_id 		 foreign key (source_id) references mb.objects(id),
	constraint fk__transactions_dest_id__object_id 			 foreign key (dest_id) references mb.objects(id)
	--constraint fk__transactions_product_id__product_id 		 foreign key (product_id) references mb.products(product_id),
	--constraint fk__transactions_secondproduct_id__product_id foreign key (second_product_id) references mb.products(product_id)
);

INSERT INTO mb.transactions
(transaction_id, case_id, source_id, dest_id, product_id, second_product_id, measured, reconciled, tolerance, abs_tolerance, techno_upper_bound, techno_lower_bound, metro_lower_bound, metro_upper_bound, object_status)
SELECT trobj.id, caseid, srcobj.id , dstobj.id , productid, secondproductid, measured, reconciled, tolerance, abstolerance, technoupperbound, technolowerbound, "MetroLowerBound", "MetroUpperBound", objectstatus
FROM public.transactions tr
left join mb.objects trobj on trobj.old_id = tr.id 
left join mb.objects srcobj on srcobj.old_id = tr.sourceid 
left join mb.objects dstobj on dstobj.old_id = tr.destid  
;

CREATE TABLE mb.ports (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	port_id int4 null,
	unit_id int4 NULL,
	flow_id int4 NULL,
	is_input int4 NULL,
	connection_obj_id int4 null,
	constraint fk__ports_port_id__objects_id foreign key (port_id) references mb.objects(id),
	constraint fk__ports_unit_id__objects_id foreign key (unit_id) references mb.objects(id),
	constraint fk__ports_flow_id__objects_id foreign key (flow_id) references mb.objects(id)
);


INSERT INTO mb.ports
(port_id, unit_id, flow_id, is_input, connection_obj_id)
SELECT pid.id, units.id, flows.id, isinput, conn.id 
FROM public.ports p
left join mb.objects pid on pid.old_id = p.id 
left join mb.objects units on units.old_id = p.unitid 
left join mb.objects flows on flows.old_id = p.flowid 
left join mb.objects conn on conn.old_id = p.connectionobjid 
;


CREATE TABLE mb.nodesvar (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	node_id int4 NULL,
	case_id int4 NULL,
	is_visible int2 NULL,
	is_mixing int2 NULL,
	min_loss float8 NULL,
	max_loss float8 NULL,
	excessive_losses float8 NULL,
	in_measured float8 NULL,
	out_measured float8 NULL,
	object_status char(2) NULL,
	root_category varchar(250) NULL,
	sub_category varchar(250) null,
	constraint pk__nodesvar_id primary key (id),
	constraint fk__nodesvar_case_id__cases_id foreign key (case_id) references mb.cases(case_id),
	constraint fk__nodesvar_node_id__objects_id foreign key (node_id) references mb.objects(id)
);

INSERT INTO mb.nodesvar
(node_id, case_id, is_visible, is_mixing, min_loss, max_loss, excessive_losses, in_measured, out_measured, object_status, root_category, sub_category)
SELECT o.id , caseid, isvisible, ismixing, minloss, maxloss, excessivelosses, ai_inmeasured, ai_outmeasured, objectstatus, rootcategory, subcategory
FROM public.nodesvar nv
left join mb.objects o on o.old_id = nv.id 
;


CREATE TABLE mb.tanksvar (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	tankvar_id int4 NULL,
	case_id int4 NULL,
	product_id int4 NULL,
	nach_product_id int4 NULL,	
	measured float8 NULL,
	nach_mass float8 NULL,	
	reconciled float8 NULL,
	tolerance float8 NULL,
	abs_tolerance float8 NULL,
	techno_upper_bound float8 NULL,
	techno_lower_bound float8 NULL,
	metro_upper_bound float8 NULL,
	metro_lower_bound float8 NULL,	
	measured_upper_bound float8 NULL,
	measured_lower_bound float8 NULL,
	excessive_losses float8 NULL,	
	tank_level float8 NULL,
	temperature float8 NULL,
	mass_free float8 NULL,
	mass_useful float8 NULL,
	mass_netto float8 NULL,
	mass_dead_min float8 NULL,
	mass_dead float8 NULL,
	maximum_volume float8 NULL,
	max_volume float8 NULL,
	mass_max_report float8 NULL,
	density float8 NULL,
	min_loss float8 NULL,
	max_loss float8 NULL,
	is_system int2 NULL,
	object_status char(2) NULL,
	grouping varchar(250) NULL,
	passport_state varchar(50) null,
	root_category varchar(250) NULL,
	sub_category varchar(250) null,
	constraint pk__tanksvar_id primary key (id),
	constraint fk__tanksvar_case_id__cases_id foreign key (case_id) references mb.cases(case_id),
	constraint fk__tanksvar_node_id__objects_id foreign key (tankvar_id) references mb.objects(id)
);

INSERT INTO mb.tanksvar
(tankvar_id, case_id, product_id, nach_product_id, measured, nach_mass, reconciled, tolerance, abs_tolerance, techno_upper_bound, techno_lower_bound, metro_upper_bound, metro_lower_bound, 
measured_upper_bound, measured_lower_bound, excessive_losses,
tank_level, temperature, mass_free, mass_useful, mass_netto, mass_dead_min, mass_dead, maximum_volume, max_volume, 
mass_max_report, density, min_loss, max_loss, is_system, object_status, grouping, passport_state,  root_category, sub_category)
SELECT o.id , caseid, productid, nachproductid, measured, nachmass,  reconciled, tolerance, abstolerance, technoupperbound, technolowerbound, metroupperbound, metrolowerbound, 
case when measured_upperbound=-1 then null else measured_upperbound end, 
case when measured_lowerbound=-1 then null else measured_lowerbound end,excessivelosses,
tanklevel, temperature, massfree, massuseful, massnetto, massdeadmin, massdead, maximumvolume, maxvolume,
massmaxreport,  density, minloss, maxloss,issystem, objectstatus,  "grouping", passportstate,   rootcategory, subcategory
FROM public.tanksvar tv
left join mb.objects o on o.old_id = tv.id ;



CREATE TABLE mb.flows_var (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	flows_var_id int4 NOT NULL,
	case_id int4 NOT NULL,
	source_id int4 NOT NULL,
	dest_id int4 NOT NULL,
	product_id int4 NULL,
	second_product_id int4 NULL,
	measured float8 NOT NULL DEFAULT 0,
	reconciled float8 NOT NULL DEFAULT 0,
	tolerance float8 NOT NULL DEFAULT 0,
	abs_tolerance float8 NULL,
	techno_upper_bound float8 NULL,
	techno_lower_bound float8 NULL,
	metro_lower_bound float8 NULL,
	metro_upper_bound float8 NULL,
	object_status bpchar(2) NULL,
	CONSTRAINT pk__flows_var_id PRIMARY KEY (id),
	CONSTRAINT fk__flows_var_case_id__cases_case_id FOREIGN KEY (case_id) REFERENCES mb.cases(case_id),
	CONSTRAINT fk__flows_var_dest_id__object_id FOREIGN KEY (dest_id) REFERENCES mb.objects(id),
	CONSTRAINT fk__flows_var_source_id__object_id FOREIGN KEY (source_id) REFERENCES mb.objects(id),
	CONSTRAINT fk__flows_var_transaction_id__object_id FOREIGN KEY (flows_var_id) REFERENCES mb.objects(id)
);

INSERT INTO mb.flows_var
(flows_var_id, case_id, source_id, dest_id, product_id, second_product_id, measured, reconciled, tolerance, 
abs_tolerance, techno_upper_bound, techno_lower_bound, metro_lower_bound, metro_upper_bound, object_status)
select 
flowsvar.id, flowsvar.case_id, flows.source_id, flows.dest_id, flowsvar.product_id, flowsvar.second_product_id, metersvar.measured, flowsvar.reconciled, metersvar.tolerance,
metersvar.abs_tolerance, metersvar.techno_upper_bound, metersvar.techno_lower_bound, metersvar.metro_lower_bound, metersvar.metro_upper_bound, flowsvar.object_status 
from mb.flowsvar flowsvar 
join mb.flows flows on flows.flow_id = flowsvar.flowsvar_id 
join mb.flowsmeters flowsmeters on flowsmeters.flow_id = flows.flow_id 
join mb.metersvar metersvar on metersvar.meter_id = flowsmeters.meter_id  and metersvar.case_id = flowsvar.case_id 
join mb.objects o on o.id = flowsmeters.id and flowsvar.case_id >= coalesce(o.create_case_id,2147483647) and flowsvar.case_id  < coalesce(o.delete_case_id,2147483647)
;