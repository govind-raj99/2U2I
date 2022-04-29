--## CREATE and ALTER TABLE staging.mm_localcalls (mm) for Local Calls from Mediation
--## Sources : mediation (MM)

--drop table staging.mmgmt ;

--CREATE TABLE staging.mmgmt (
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

with a as (select *, 'BPO_MM' as data_source from staging.bpo_mm bm UNION ALL select *,'CYN_MM' as data_source from staging.cyn_mm cm),

b as (
select 
trim(substring(a.stagecol,18,10)) called_party_number,
regexp_replace(trim(substring(a.stagecol,18,10)) , '(\d{4})(\d{2})(\d{4})', '\1-\2-\3') tollfree,
case 
	when length(trim(substring(a.stagecol,28,15)) ) = 11 then regexp_replace(trim(substring(a.stagecol,28,15)) , '(\d{3})(\d{4})(\d{4})', '(\1) \2-\3')
	when length(trim(substring(a.stagecol,28,15)) ) = 10 then regexp_replace(trim(substring(a.stagecol,28,15)) , '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
	when length(trim(substring(a.stagecol,28,15)) ) = 9 then regexp_replace(trim(substring(a.stagecol,28,15)) , '(\d{2})(\d{3})(\d{4})', '(\1) \2-\3') 
	else trim(substring(a.stagecol,28,15)) 
end as answerpoint,
trim(substring(a.stagecol,1,17)) as caller,
trim(substring(a.stagecol,42,24))::timestamptz as startdatetime,
to_char(trim(substring(a.stagecol,42,24))::timestamptz,'Dy') as dy,
to_char(trim(substring(a.stagecol,42,24))::timestamptz,'hh24') :: numeric as hr,
trim(substring(a.stagecol,68,6)) :: numeric as duration,
trim(substring(a.stagecol,68,6)) :: interval as dduration,
a.data_source
from a
),

c as (
select 
cp.account_num,
cp.customer_name,
b.called_party_number,
b.tollfree,
b.answerpoint,
case	
	when length(b.caller) = 17 and left(b.caller,6) like '00%12%' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
	when length(b.caller) = 17 and left(b.caller,6) like '00%14%' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
	when length(b.caller) = 17 and left(b.caller,6) like '08%%12' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
	when length(b.caller) = 17 and left(b.caller,6) like '08%%14' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
	when length(b.caller) = 16 and left(b.caller,6) like '00%12%' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
	when length(b.caller) = 16 and left(b.caller,6) like '00%14%' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
	when length(b.caller) = 16 and left(b.caller,5) like '08%12' then regexp_replace(b.caller, '(\d{0})(\d{5})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
	when length(b.caller) = 16 and left(b.caller,5) like '08%14' then regexp_replace(b.caller, '(\d{0})(\d{5})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
	when length(b.caller) = 15 and left(b.caller,5) like '08%12' then regexp_replace(b.caller, '(\d{5})(\d{3})(\d{3})(\d{4})', '(\2) \3-\4')
	when length(b.caller) = 15 and left(b.caller,5) like '08%14' then regexp_replace(b.caller, '(\d{5})(\d{3})(\d{3})(\d{4})', '(\2) \3-\4')	
	when length(b.caller) = 11 and left(b.caller,3) like '01%' then regexp_replace(b.caller,'(\d{3})(\d{4})(\d{4})', '(\1) \2-\3')
	when length(b.caller) = 11 and left(b.caller,3) like '00%' then regexp_replace(b.caller,'(\d{3})(\d{4})(\d{4})', '(\1) \2-\3')
	when length(b.caller) = 10 and left(b.caller,3) like '00%' then regexp_replace(b.caller,'(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
	when length(b.caller) = 9 and left(b.caller,3) like '08%' then regexp_replace(b.caller,'(\d{3})(\d{3})(\d{3})', '(\1) \2-\3')
	else b.caller
end as caller,
case	
	when length(b.caller) = 17 and left(b.caller,6) like '00%12%' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{4})(\d{4})', '\2')
	when length(b.caller) = 17 and left(b.caller,6) like '00%14%' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{4})(\d{4})', '\2')
	when length(b.caller) = 17 and left(b.caller,6) like '08%%12' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{4})(\d{4})', '\2')
	when length(b.caller) = 17 and left(b.caller,6) like '08%%14' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{4})(\d{4})', '\2')
	when length(b.caller) = 16 and left(b.caller,6) like '00%12%' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{3})(\d{4})', '\2')
	when length(b.caller) = 16 and left(b.caller,6) like '00%14%' then regexp_replace(b.caller, '(\d{1})(\d{5})(\d{3})(\d{3})(\d{4})', '\2')	
	when length(b.caller) = 16 and left(b.caller,5) like '08%12' then regexp_replace(b.caller, '(\d{0})(\d{5})(\d{3})(\d{4})(\d{4})', '\2')
	when length(b.caller) = 16 and left(b.caller,5) like '08%14' then regexp_replace(b.caller, '(\d{0})(\d{5})(\d{3})(\d{4})(\d{4})', '\2')
	when length(b.caller) = 15 and left(b.caller,5) like '08%12' then regexp_replace(b.caller, '(\d{5})(\d{3})(\d{3})(\d{4})', '\1')
	when length(b.caller) = 15 and left(b.caller,5) like '08%14' then regexp_replace(b.caller, '(\d{5})(\d{3})(\d{3})(\d{4})', '\1')		
	when length(b.caller) = 11 and left(b.caller,3) like '01%' then regexp_replace(b.caller,'(\d{3})(\d{4})(\d{4})', '\1')
	when length(b.caller) = 11 and left(b.caller,3) like '00%' then regexp_replace(b.caller,'(\d{3})(\d{4})(\d{4})', '\1\2')
	when length(b.caller) = 10 and left(b.caller,3) like '00%' then regexp_replace(b.caller,'(\d{3})(\d{3})(\d{4})', '\1\2')
	when length(b.caller) = 9 and left(b.caller,3) like '08%' then regexp_replace(b.caller,'(\d{3})(\d{3})(\d{3})', '\1\2')	
	else null 
end as prefix,
b.startdatetime,
b.dy,
b.hr,
b.duration,
b.dduration,
case when EXTRACT(EPOCH FROM b.dduration :: interval) < 60 then 1 else 0 end as call60sec,
b.data_source
from b 
--LEFT JOIN ref.custprof cp on b.called_party_number = cp.service_num
--LEFT JOIN ref.custprof cp on b.called_party_number = cp.service_num -- Wrong because choose ref.custprof
LEFT JOIN ref.custtbl cp on b.called_party_number = cp.service_num -- Right because choose ref.custtbl

)

insert into staging.mmgmt (
select 
	nextval('staging.mmgmt_id_seq') as id,
	c.startdatetime,
	c.customer_name,
	c.account_num,
	c.tollfree,
	c.answerpoint,
	c.caller,
	c.dy,
	case 
		when c.hr >= 0 and c.hr <=2 then '12AM - 2AM'
		when c.hr >= 3 and c.hr <=4 then '3AM - 4AM'
		when c.hr >= 5 and c.hr <=6 then '5AM - 6AM'
		when c.hr >= 7 and c.hr <=8 then '7AM - 8AM'
		when c.hr >= 9 and c.hr <=10 then '9AM - 10AM'
		when c.hr >= 11 and c.hr <=12 then '11AM - 12PM'
		when c.hr >= 13 and c.hr <=14 then '1PM - 2PM'
		when c.hr >= 15 and c.hr <=16 then '3PM - 4PM'
		when c.hr >= 17 and c.hr <=18 then '5PM - 6PM'
		when c.hr >= 19 and c.hr <=20 then '7PM - 8PM'
		when c.hr >= 21 and c.hr <=22 then '9PM - 10PM'
		when c.hr >= 23 and c.hr <=24 then '11PM - 12AM'
		else null
	end as hr,
	c.duration,
	c.dduration,
	c.call60sec,
	0 call_cost_cent,
	0 call_cost_rm,
	'Local Call' call_type,
	'Answered Call' call_status,
	'Answered Call' stop_reason, --'Answred Call' stop_reason,
	p.area,
	p.state,
	p.region,
	c.data_source
from c 
LEFT JOIN ref.prefix p on c.prefix = p.prefix_range
where extract(year from startdatetime) = 2018
);
