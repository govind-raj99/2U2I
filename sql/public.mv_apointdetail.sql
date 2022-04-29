--drop materialized view mv_apointdetail;

create materialized view mv_apointdetail
AS
(select
billing ,
tollfree ,
customer_name ,
account_num ,
answerpoint ,
caller,
call_date ,
call_time ,
duration ,
dduration :: interval ,
"cost" * 0.01 cost_rm ,
area 
from view_callsummary
)