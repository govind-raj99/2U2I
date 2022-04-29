--##Overview By Day
--drop table data.overviewbyday;

--create table data.overviewbyday (
--	tollfree text,
--	date date,
--	day text,
--	total_calls numeric,
--	call60sec numeric,
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
SELECT 
	ds.tollfree,
	ds.startdatetime::date as date,
	ds.day,
	ds.call60sec,
	EXTRACT(EPOCH FROM ds.duration :: interval) duration,
	ds.call_cost_rm,
	ds.call_status,
	case 
		when ds.stop_reason = 'Called Busy' then ds.stop_reason
		when ds.stop_reason = 'No Answer' then ds.stop_reason
		when ds.stop_reason = 'Answered Call' then 'Answered Call'
		else 'Other'
	end as stop_reason

FROM DATA.successful ds

union all

SELECT 
	du.tollfree,
	du.startdatetime::date as date,
	du.day,
	du.call60sec,
	EXTRACT(EPOCH FROM du.duration :: interval) duration,
	du.call_cost_rm,
	du.call_status,
	case 
		when du.stop_reason = 'Called Busy' then du.stop_reason
		when du.stop_reason = 'No Answer' then du.stop_reason
		when du.stop_reason = 'Answered Call' then 'Answered Call'
		else 'Other'
	end as stop_reason

FROM DATA.unsuccessful du

),

b as (
select
tollfree,
date,
day,
sum(case when a.tollfree is not null then 1 else 0 end) as total_calls,
sum(case when a.call60sec = 'Calls < 60s' then 1 else 0 end) as call60sec,
sum(a.duration) as total_duration,
round(avg(a.duration)::numeric,0) as avg_duration,
sum(a.call_cost_rm) total_cost,
sum(case when a.stop_reason = 'Called Busy' then 1 else 0 end) as busy,
sum(case when a.stop_reason = 'No Answer' then 1 else 0 end) as no_answer,
sum(case when a.stop_reason = 'Other' then 1 else 0 end) as other,
sum(case when a.call_status = 'Unanswered Call' then 1 else 0 end) as total_incomplete,
sum(case when a.call_status = 'Answered Call' then 1 else 0 end) as total_complete
from a group by tollfree,date,day
)

--insert into data.overviewbyday (
select 
	*,
	round((sum(b.total_incomplete::numeric/b.total_calls::numeric)*100),2) AS pct_incomplete
from b group by 
	tollfree,
	date,
	day,
	total_calls,
	call60sec,
	total_duration,
	avg_duration,
	total_cost,
	busy,
	no_answer,
	other,
	total_incomplete,
	total_complete
--);

--ALTER TABLE data.overviewbyday ADD COLUMN ID SERIAL PRIMARY KEY;