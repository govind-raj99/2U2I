with a as (
select 'bpo_brm' as ds, max(date_time),min(date_time) from staging.bpo_brm
union
select 'cyn_brm' as ds, max(date_time),min(date_time) from staging.cyn_brm
union
select 'bpo_ime' as ds, max(start_date_time),min(start_date_time) from staging.bpo_ime
union
select 'cyn_ime' as ds, max(start_date_time),min(start_date_time) from staging.cyn_ime
union
select 'bpo_mm' as ds, max(trim(substring(stagecol,42,24))),min(trim(substring(stagecol,42,24))) from staging.bpo_mm
union
select 'cyn_mm' as ds, max(trim(substring(stagecol,42,24))),min(trim(substring(stagecol,42,24))) from staging.cyn_mm
union
select 'tellin' as ds, max(start_date_time),min(start_date_time) from staging.tellin
	)
select
ds,
case when length(min)=13 then substring(min,1,6)::date else substring(min,1,8)::date end as mindate,
case when length(max)=13 then substring(max,1,6)::date else substring(max,1,8)::date end as maxdate
from a order by max

