CREATE MATERIALIZED VIEW public.mv_callsummary
AS (
select * from public.view_callsummary
);

refresh MATERIALIZED VIEW public.mv_callsummary;

--DROP MATERIALIZED VIEW public.mv_callsummary;