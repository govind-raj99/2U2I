-- ## State Region Summary Unbilled
-- ## Source is from RAW Successful CDR that has been processed by MEDIATION - but not categorized into Local Calls (MM) or STD Calls (BRM)

--drop table data.state_unbilled;

--create table data.unbilled (
--	tollfree text,
--	date date,
--	area text,
--	state text,
--	region text,
--	total_calls numeric,
--	total_duration numeric,
--	avg_duration numeric,
--	total_cost numeric,
--	busy numeric,
--	no_answer numeric,
--	other numeric,
--	total_incomplete numeric,
--	total_complete numeric,
--	pct_incomplete numeric
--);


with a as (
select 
	s.id,
	s.startdatetime,
	s.customer_name,
	s.account_num,
	s.tollfree,
	s.answerpoint,
	s.caller,
	s.dy,
	s.hr,
	s.duration,
	s.dduration,
	s.call60sec,
	s.call_cost_cent,
	s.call_cost_rm,
	s.call_type,
	s.call_status,
	s.stop_reason,
	s.area,
	s.state,
	s.region,
	s.data_source from data.successful s union all select * from data.unsuccessful us),

b as (
select
a.tollfree,
a.startdatetime :: date date,
a.area,
a.state,
a.region,
sum(case when a.tollfree is not null then 1 else 0 end) as total_calls,
sum(a.dduration) as total_duration,
round(avg(a.duration)::numeric,0) as avg_duration,
sum(a.call_cost_rm) total_cost,
sum(case when a.stop_reason = 'Called Busy' then 1 else 0 end) as busy,
sum(case when a.stop_reason = 'No Answer' then 1 else 0 end) as no_answer,
sum(case when a.stop_reason = 'Other' then 1 else 0 end) as other,
sum(case when a.call_status = 'Unanswered Call' then 1 else 0 end) as total_incomplete,
sum(case when a.call_status = 'Answered Call' then 1 else 0 end) as total_complete
from a group by a.startdatetime,a.tollfree,a.area,a.state,a.region
)

--insert into data.unbilled (
select 
	*,
	round((sum(b.total_incomplete::numeric/b.total_calls::numeric)*100),2) AS pct_incomplete
from b group by 
	b.tollfree,
	b.date,
	b.area,
	b.state,
	b.region,
	b.total_calls,
	b.total_duration,
	b.avg_duration,
	b.total_cost,
	b.busy,
	b.no_answer,
	b.other,
	b.total_incomplete,
	b.total_complete
--);

--ALTER TABLE data.unbilled ADD COLUMN ID SERIAL PRIMARY KEY;