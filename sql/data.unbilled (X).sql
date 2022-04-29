-- ## State Region Summary Unbilled
-- ## Source is from RAW Successful CDR that has been processed by MEDIATION - but not categorized into Local Calls (MM) or STD Calls (BRM)
-- ## Source is from data.successful UNION ALL data.unsuccessful_19.05.2021

--drop table data.state_unbilled;

/*CREATE TABLE "data".unbilled (
	id SERIAL primary key NOT NULL,
	startdatetime timestamptz,
	customer_name text,
	account_num text,
	tollfree text,
	answerpoint text,
	caller text,
	dy text,
	hr text,
	duration numeric,
	dduration interval,
	call60sec numeric,
	call_cost_cent numeric,
	call_cost_rm numeric,
	call_type text,
	call_status text,
	stop_reason text,
	area text,
	state text,
	region text,
	data_source text
);*/


with a as 
(
select * from data.successful s union all select * from data.unsuccessful u 
)	

insert into data.unbilled
(
select 
	nextval('data.unbilled_id_seq') as id,
	a.startdatetime,
	a.customer_name,
	a.account_num,
	a.tollfree,
	a.answerpoint,
	a.caller,
	a.dy,
	a.hr,
	a.duration,
	a.dduration,
	a.call60sec,
	a.call_cost_cent,
	a.call_cost_rm,
	a.call_type,
	a.call_status,
	a.stop_reason,
	a.area,
	a.state,
	a.region,
	a.data_source
from a
--where extract(year from startdatetime) = 2018
where extract(year from startdatetime) = 2020 
order by startdatetime ASC
)