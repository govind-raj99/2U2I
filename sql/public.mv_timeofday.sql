--drop materialized view mv_timeofday

create materialized view mv_timeofday
AS
(
select 
billing ,
tollfree ,
customer_name ,
account_num ,
hr_id ,
hr ,
call_date ,
sum(calls) as total_calls,
sum(busy) as total_busy,
sum(no_answer) as total_no_answer ,
sum(other) as total_other,
sum(incomplete) as total_incomplete,
sum(complete) as total_complete
from view_callsummary
group by billing , call_date , account_num , customer_name , tollfree , hr_id , hr 
)