--drop materialized view mv_apoint_summary;

create materialized view mv_apoint_summary
AS
(select
billing ,
tollfree ,
customer_name ,
account_num ,
answerpoint ,
call_date ,
sum(calls) as total_calls,
sum(dduration) :: interval total_dduration,
avg(dduration) :: interval avg_dduration,
sum(busy)as total_busy,
sum(no_answer)as total_no_answer,
sum(other) as total_other,
sum(incomplete) as total_incomplete,
sum(complete) as total_complete,
((sum(incomplete))/(sum(calls))) * 100 as pctg_incomplete,
sum("cost")*0.01 as total_cost
from view_callsummary vc 
group by billing ,call_date, account_num , customer_name , tollfree ,answerpoint
order by total_calls desc, answerpoint asc 
)

/*CREATE UNIQUE INDEX tollfree_apoint_idx
ON mv_apoint_summary (billing, tollfree, account_num,answerpoint, call_date);*/

/*select * from tollfree_apoint_idx
where public.mv_apoint_summary;*/
  
--refresh materialized view mv_apoint_summary;