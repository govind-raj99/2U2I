-- ## UNION from bpo_brm and cyn_brm for STD Calls
-- ## Sources : staging.bpo_brm & staging.bpo_brm

--drop table staging.brm_stdcalls;

--CREATE TABLE staging.obrm (
--	id SERIAL primary key NOT NULL,
--	startdatetime timestamptz,
--	customer_name text,
--	account_num text,
--	tollfree text,
--	answerpoint text,
--	caller text,
--	dy text,
--	hr text,
--	duration numeric,
--	dduration interval,
--	call60sec numeric,
--	call_cost_cent numeric,
--	call_cost_rm numeric,
--	call_type text,
--	call_status text,
--	stop_reason text,
--	area text,
--	state text,
--	region text,
--	data_source text
--);

with a as (select * ,'BPO_BRM' as data_source from staging.bpo_brm bb union all select * ,'CYN_BRM' as data_source from staging.cyn_brm cb),

b as (
select 
	cb.customer_name,
	cb.account_num,
	a.called_number,
	case 
		when left(a.called_number,1) != '1' then regexp_replace(a.called_number, '(\d{3})(\d{2})(\d{5})', '\3')
		else regexp_replace(a.called_number, '(\d{4})(\d{2})(\d{4})', '\1-\2-\3')
	end as tollfree,
	case 
		when length(a.translated_number) = 11 then regexp_replace(a.translated_number, '(\d{3})(\d{4})(\d{4})', '(\1) \2-\3')
		when length(a.translated_number) = 10 then regexp_replace(a.translated_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.translated_number) = 9 then regexp_replace(a.translated_number, '(\d{3})(\d{3})(\d{3})', '(\1) \2-\3') 
		when length(a.translated_number) = 8 then regexp_replace(a.translated_number, '(\d{3})(\d{5})', '\2') 
		else a.translated_number
	end as answerpoint,
	a.caller_number,
	case
  		when length(a.caller_number) = 11 then regexp_replace(a.caller_number, '(\d{3})(\d{4})(\d{4})', '(\1) \2-\3') 
  		when length(a.caller_number) = 10 then regexp_replace(a.caller_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
  		when length(a.caller_number) = 9 then regexp_replace(a.caller_number, '(\d{3})(\d{3})(\d{3})', '(\1) \2-\3')
   		else a.caller_number 
   	end as caller,
   	case
		when length(a.caller_number) = 11 and left(a.caller_number,3) like '00%' then regexp_replace(a.caller_number, '(\d{3})(\d{4})(\d{4})', '\1\2') 
		when length(a.caller_number) = 11 and left(a.caller_number,3) like '01%' then regexp_replace(a.caller_number, '(\d{3})(\d{4})(\d{4})', '\1')
		when length(a.caller_number) = 10 and left(a.caller_number,3) like '00%' then regexp_replace(a.caller_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.caller_number) = 10 and left(a.caller_number,3) like '01%' then regexp_replace(a.caller_number, '(\d{3})(\d{3})(\d{4})', '\1')
		when length(a.caller_number) = 9 then regexp_replace(a.caller_number, '(\d{3})(\d{3})(\d{3})', '\1\2')
		else a.caller_number 
	end as prefix,
	regexp_replace(a.date_time, '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})', '\1-\2-\3 \4:\5:\6') :: timestamp startdatetime,
	to_char(regexp_replace(a.date_time, '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})', '\1-\2-\3 \4:\5:\6') :: timestamp,'Dy') as dy,
	to_char(regexp_replace(a.date_time, '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})', '\1-\2-\3 \4:\5:\6') :: timestamp,'hh24') :: numeric as hr,
	a.duration :: numeric duration,
	a.duration :: interval dduration,
	case when EXTRACT(EPOCH FROM duration :: interval) < 60 then 1 else 0 end as call60sec,
    a.rated_chrg_amt :: numeric as call_cost_cent,
	(a.rated_chrg_amt :: numeric * 0.01) as call_cost_rm,
	a.data_source
from a 
JOIN ref.custtbl cb on a.called_number = cb.service_num 

),

temp as (
--insert into staging.obrm (
select distinct on (b.startdatetime,b.tollfree,b.caller)
	nextval('staging.obrm_id_seq') as id,
	b.startdatetime,
	cb.customer_name,
	cb.account_num,
	b.tollfree,
	b.answerpoint,
	b.caller,	
	b.dy,
	case 
		when b.hr >= 0 and b.hr <=2 then '12AM - 2AM'
		when b.hr >= 3 and b.hr <=5 then '3AM - 5AM'
		when b.hr >= 6 and b.hr <=8 then '6AM - 8AM'
		when b.hr >= 9 and b.hr <=11 then '9AM - 11AM'
		when b.hr >= 12 and b.hr <=14 then '12PM - 2PM'
		when b.hr >= 15 and b.hr <=17 then '3PM - 5PM'
		when b.hr >= 18 and b.hr <=20 then '6PM - 8PM'
		when b.hr >= 21 and b.hr <=23 then '9PM - 11PM'
	else null
	end as hr,
	b.duration,
	b.dduration,
	b.call60sec,
	call_cost_cent,
	call_cost_rm,
	'Domestic Call' call_type,
	'Answered Call' call_status,
	'Answered Call' stop_reason,
	p.area,
	p.state,
	p.region,
	b.data_source
FROM b 
left JOIN ref.custtbl cb on b.called_number = cb.service_num
left JOIN ref.prefix p on b.prefix = p.prefix_range
where extract(year from b.startdatetime) = 2021 and b.customer_name is not null
--);
)
select count(caller) from temp
