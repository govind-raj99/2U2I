
CREATE MATERIALIZED VIEW public.matview_overview
AS 
select 
	*
from view_overview v
where
v.date > (
select
	(max(v.date) - interval '3 months') :: date 
from view_overview v
);

