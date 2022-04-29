CREATE MATERIALIZED VIEW public.matview_stateregion_unbilled
AS 
select 
	*
from view_stateregion_unbilled s
where
s.date > (
select
	(max(s.date) - interval '3 months') :: date 
from view_stateregion_unbilled s
);

