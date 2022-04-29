CREATE view public.view_ubcallsummary as(
select distinct on (b.startdatetime,b.tollfree,b.caller)
b.startdatetime,
b.tollfree,
b.answerpoint,
b.customer_name, 
b.account_num , 
b.caller,
b.startdatetime :: date date,
b.hr,
b.dy,
b.area,
b.state,
b.region,
count(b.caller) as total_calls,
--sum(case when b.tollfree is not null then 1 else 0 end) as total_calls,
sum(b.call60sec) as "calls<60sec",
sum(b.duration) as total_duration,
round(avg(b.duration)::numeric,0) as avg_duration,
sum(b.call_cost_cent) total_cost,
sum(case when b.stop_reason = 'Called Busy' then 1 else 0 end) as busy,
sum(case when b.stop_reason = 'No Answer' then 1 else 0 end) as no_answer,
sum(case when b.stop_reason = 'Other' then 1 else 0 end) as other,
sum(case when b.call_status = 'Unanswered Call' then 1 else 0 end) as total_incomplete,
sum(case when b.call_status = 'Answered Call' then 1 else 0 end) as total_complete,
100 * (
sum(case when b.call_status = 'Unanswered Call' then 1 else 0 end) / count(b.caller)) pctg
from "data".unbilled b
where
b.startdatetime > (
select
(max(b.startdatetime) - interval '3 months') :: date 
from "data".unbilled b
where b.call_status = 'Unanswered Call'
)
group by b.startdatetime,b.hr,b.dy, b.tollfree,b.answerpoint, b.customer_name, b.account_num,b.caller, b.area,b.state, b.region
order by b.startdatetime asc, b.tollfree , b.caller
);
