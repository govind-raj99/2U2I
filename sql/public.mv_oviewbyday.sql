CREATE MATERIALIZED VIEW public.mv_oviewbyday
AS (
(
select 
a.billing ,
a.tollfree ,
a.customer_name ,
a.account_num ,
a.call_date ,
sum(a.calls) as total_calls,
sum(a."calls<60sec") as "total_calls<60sec",
sum(incomplete) as total_incomplete,
sum(complete) as total_complete
from public.mv_callsummary a 
where tollfree = '1800-22-0800'
group by a.billing ,a.tollfree ,a.customer_name ,a.account_num, a.call_date
)
)
--DROP MATERIALIZED VIEW public.mv_mv_oviewbyday;