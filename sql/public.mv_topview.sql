
drop materialized view mv_topview

create materialized view mv_topview
AS
(
select
billing ,
tollfree ,
customer_name ,
account_num ,
caller ,
answerpoint ,
call_date ,
call_time ,
dduration ,
"cost" * 0.01 cost_rm
from view_callsummary a
)