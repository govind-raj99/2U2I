CREATE view public.view_stateregion_unbilled as(
select 
a.tollfree,
a.ddate date,
a.day,
a.state,
a.region,
count(a.caller) total_calls,
sum(a.call60sec) "calls<60sec",
sum(a.duration) total_duration,
avg(a.int_duration)::numeric(10,2) avg_duration,
sum(a.call_cost) total_cost,
sum(a.busy) busy,
sum(a.no_answer) no_answer,
sum(a.other) other,
sum(a.incomplete) incomplete,
sum(a.complete) completed,
round(100 * (sum(a.incomplete) / count(a.tollfree)),0) "incomplete_pct"
from data.overview a  
group by a.tollfree, a.ddate, a.day,a.state,a.region
order by a.ddate ASC
);
