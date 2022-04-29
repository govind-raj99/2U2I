create or replace view public.view_ubcallsummary as
--insert into public.view_bcallsummary 
(
select distinct on (b.startdatetime,b.tollfree,b.caller)
b.startdatetime,
b.tollfree ,
b.answerpoint ,
b.customer_name ,
b.account_num ,
b.caller ,
b.startdatetime :: date call_date ,
b.startdatetime :: time call_time ,
b.hr,
b.dy,
b.area,
b.state,
b.region,
case when b.caller is not null then 1 else 0 end as calls,
--b.caller as total_calls,
--sum(case when b.tollfree is not null then 1 else 0 end) as total_calls,
b.call60sec as "calls<60sec",
b.duration ,
b.dduration :: interval,
--0 as avg_duration,
b.call_cost_cent as cost,
b.busy :: integer,
b.no_answer :: integer,
b.other :: integer ,
--case when b.stop_reason = 'Called Busy' then 1 else 0 end as busy,
--case when b.stop_reason = 'No Answer' then 1 else 0 end as no_answer,
--case when b.stop_reason = 'Other' then 1 else 0 end as other,
case when b.call_status = 'Unanswered Call' then 1 else 0 end as incomplete,
case when b.call_status = 'Answered Call' then 1 else 0 end as complete
--0 as pctg
from "data".unbilled b
where
(b.startdatetime > (
select
(max(b2.startdatetime) - interval '3 months') :: date 
from "data".unbilled b2)
)
)
;