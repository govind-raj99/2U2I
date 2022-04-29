--## Billed BRM successful STD CDR
--## Sources : staging.brm_stdcalls 

--drop table data.billed;

--create table data.billed (
--	id SERIAL primary key NOT NULL,
--	customer_name text,
--	account_num text,
--	tollfree text,
--	answerpoint text,
--	caller text,
--	startdatetime timestamptz,
--	dy text,
--	hr text,
--	duration numeric,
--	dduration interval,
--	call60sec numeric,
--	call_cost_cent numeric,
--	call_cost_rm numeric,
--	call_type text,
--	call_status text,
--	stop_reason text,
--	area text,
--	state text,
--	region text,
--	data_source text
--);


with a as (
select 
	bs.customer_name,
 	bs.account_num,	
	bs.tollfree,
	bs.answerpoint,
	bs.caller,
	bs.startdatetime,
	to_char(bs.startdatetime,'Dy') as dy,
	to_char(bs.startdatetime,'hh24') :: numeric as hr,
	bs.duration,
	bs.dduration,
	bs.call60sec,
	bs.call_cost,
	sc.call_type,
	sc.call_status,
	sc.stop_reason,
	bs.area,
	bs.state,
	bs.region,
	bs.data_source	
from staging.brm_stdcalls bs
LEFT JOIN data.successful sc on bs.caller = sc.caller and bs.startdatetime = sc.startdatetime
)

--insert into data.billed (
select
	nextval('data.billed_id_seq') as id,
	a.customer_name,
 	a.account_num,	
	a.tollfree,
	a.answerpoint,
	a.caller,
	a.startdatetime,
	a.dy,
	a.hr,
	a.duration,
	a.dduration,
	a.call60sec,
	--a.call_cost_cent,
	--a.call_cost_rm,
	case when a.call_type is null then 'Local Call' else a.call_type end as call_type,
	case when a.call_status is null then 'Answered Call' else a.call_status end as call_status,
	case when a.stop_reason is null then 'Answered Call' else a.stop_reason end as stop_reason,
	a.area,
	a.state,
	a.region,
	a.data_source	
from a
--);