--##Overview By Day
--drop table data.overview;

--create table data.overview (
--	account_num	text,
--	customer_name text,
--	tollfree	text,
--	answerpoint	text,
--	caller	text,
--	startdatetime	timestamp,
--	ddate	date,
--	ttime	time,
--	hr	text,
--	day	text,
--	duration numeric,
--	dduration interval,
--	call60sec	numeric,
--	call_cost	numeric,
--	call_type	text,
--	call_status	text,
--	stop_reason	text,
--	incomplete	numeric,
--	complete	numeric,
--	busy	numeric,
--	no_answer	numeric,
--	other	numeric,
--	area	text,
--	state	text,
--	region	text,
--	data_source text,
--	tsource	text
--);

with 
a as (select *, 'data.unsuccessful' as tsource from data.unsuccessful),-- union select *, 'data.successful' as tsource from data.successful),
b as (	select *, 
		a.startdatetime :: date ddate,
		a.startdatetime :: time ttime,
		extract(hour FROM a.startdatetime) hr,
		case when a.call_status = 'Unanswered Call' then 1 else 0 end as incomplete,
		case when a.call_status = 'Answered Call' then 1 else 0 end as complete,
		case when a.stop_reason = 'Called Busy' then 1 else 0 end as busy,
		case when a.stop_reason = 'No Answer' then 1 else 0 end as no_answer,
		case when a.stop_reason != 'Called Busy'and a.stop_reason != 'No Answer' then 1 else 0 end as other
from a
)

--insert into data.overview (
select
	b.account_num,
	b.customer_name,
	b.tollfree,
	b.answerpoint,
	b.caller,
	b.startdatetime,
	b.ddate,
	b.ttime,
	case 
		when hr >= 0 and hr <=2 then '12AM - 2AM'
		when hr >= 3 and hr <=4 then '3AM - 4AM'
		when hr >= 5 and hr <=6 then '5AM - 6AM'
		when hr >= 7 and hr <=8 then '7AM - 8AM'
		when hr >= 9 and hr <=10 then '9AM - 10AM'
		when hr >= 11 and hr <=12 then '11AM - 12PM'
		when hr >= 13 and hr <=14 then '1PM - 2PM'
		when hr >= 15 and hr <=16 then '3PM - 4PM'
		when hr >= 17 and hr <=18 then '5PM - 6PM'
		when hr >= 19 and hr <=20 then '7PM - 8PM'
		when hr >= 21 and hr <=22 then '9PM - 10PM'
		when hr >= 23 and hr <=24 then '11PM - 12AM'
		else null
	end as hr,
	b.day,
	b.duration,
	b.dduration,
	b.call60sec,
	b.call_cost,
	b.call_type,
	b.call_status,
	b.stop_reason,
	b.incomplete,
	b.complete,
	b.busy,
	b.no_answer,
	case when b.complete = 1 then 0 else b.other end as other,
	b.area,
	b.state,
	b.region,
	b.data_source,
	upper(b.tsource) as tsource
from b order by b.startdatetime asc
--); ALTER TABLE data.overview ADD COLUMN ID SERIAL PRIMARY KEY;