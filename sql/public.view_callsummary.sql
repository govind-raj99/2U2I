--drop VIEW public.view_callsummary;

--select * from public.view_callsummary vc where billing = 'Unbilled'

create or replace view public.view_callsummary as
--insert into public.view_bcallsummary 
(
(select 
ub.startdatetime,
ub.tollfree ,
ub.answerpoint ,
ub.customer_name ,
ub.account_num ,
ub.caller ,
ub.startdatetime :: date call_date ,
ub.startdatetime :: time call_time ,
ub.hr,
ub.dy,
ub.area,
ub.state,
ub.region,
case when ub.caller is not null then 1 else 0 end as calls,
ub.call60sec as "calls<60sec",
ub.duration ,
ub.dduration :: interval,
--0 as avg_duration,
ub.call_cost_cent as cost,
case when ub.stop_reason = 'Called Busy' then 1 else 0 end as busy,
case when ub.stop_reason = 'No Answer' then 1 else 0 end as no_answer,
case when ub.stop_reason not in ('Called Busy','No Answer','Answered Call') then 1 else 0 end as other,
case when ub.call_status = 'Unanswered Call' then 1 else 0 end as incomplete,
case when ub.call_status = 'Answered Call' then 1 else 0 end as complete,
ub.dur_range ,
ub.reason ,
ub.hr_id, 
ub.state_id ,
ub.dur_range_id,
'Unbilled' as billing
--0 as pctg
from "data".unbilled ub
where
ub.account_num is not null
and 
(ub.startdatetime > (
select
(max(ub1.startdatetime) - interval '3 months') :: date 
from "data".unbilled ub1)
)
)


union all

(select 
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
b.call60sec as "calls<60sec",
b.duration ,
b.dduration :: interval,
--0 as avg_duration,
b.call_cost_cent as cost,
0 as busy,
0 as no_answer,
0 as other,
case when b.call_status = 'Unanswered Call' then 1 else 0 end as incomplete,
case when b.call_status = 'Answered Call' then 1 else 0 end as complete,
b.dur_range ,
null as reason ,
b.hr_id, 
b.state_id ,
b.dur_range_id,
'Billed' as billing
--0 as pctg
from "data".billed b
where
b.account_num is not null
and 
(b.startdatetime > (
select
(max(b1.startdatetime) - interval '3 months') :: date 
from "data".billed b1)
)
)
)