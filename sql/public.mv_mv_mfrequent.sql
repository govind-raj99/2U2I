--drop materialized view mv_mfrequent

create materialized view mv_mfrequent
as (
select
billing ,
tollfree ,
customer_name ,
account_num ,
caller ,
call_date,
sum(calls) as total_calls,
avg(dduration) as avg_dduration,
sum(dduration) as total_dduration,
(sum("cost"))* 0.01 as total_cost_rm
from view_callsummary a
group by billing ,call_date, account_num, customer_name, tollfree, caller
order by total_calls desc 
)

