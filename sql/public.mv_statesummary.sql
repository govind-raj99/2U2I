--DROP MATERIALIZED VIEW public.mv_statesummary;

CREATE MATERIALIZED VIEW public.mv_statesummary
AS (
SELECT coalesce(state , 'UNKNOWN') as state, 
billing ,
account_num ,
customer_name ,
tollfree ,
call_date,
state_id ,
sum(calls) as total_calls
from public.view_callsummary vc 
group by billing , call_date, account_num , customer_name ,tollfree , state_id , state
);

