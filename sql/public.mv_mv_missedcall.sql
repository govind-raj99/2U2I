create materialized view mv_missedcall
AS(
select
billing ,
tollfree ,
customer_name ,
account_num ,
caller ,
call_date ,
call_time ,
reason 
from view_callsummary a
where busy = 1 or no_answer = 1 or other = 1
order by call_date desc 
)
