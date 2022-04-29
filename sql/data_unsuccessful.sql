--## CREATE and updating TABLE data.unsuccessful (tellin) for Raw Unsuccessful CDR - Near real time
--## Sources : TELLIN

--drop table data.unsuccessful;

--create table data.unsuccessful (
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

WITH t1 AS ( 
select
	called_party_number,
	case
		when length(called_party_number) = 10 then regexp_replace(called_party_number, '(\d{4})(\d{2})(\d{4})', '\1-\2-\3') 
		when length(called_party_number) = 9 then regexp_replace(called_party_number, '(\d{4})(\d{2})(\d{3})', '\1-\2-\3')
	end as tollfree,
	length(calling_party_number) len,
	case 
		when length(trans_party_number) = 13 and left(trans_party_number,5) = '00603' then regexp_replace(trans_party_number, '(\d{3})(\d{2})(\d{4})(\d{4})', '(0\2) \3-\4')
		when length(trans_party_number) = 13 and left(trans_party_number,5) = '11200' then regexp_replace(trans_party_number, '(\d{3})(\d{2})(\d{4})(\d{4})', '(003) \3-\4')
		when length(trans_party_number) = 13 and left(trans_party_number,4) = '0011' then regexp_replace(trans_party_number, '(\d{1})(\d{3})(\d{4})(\d{4})', '(\2) \3-\4')
		when length(trans_party_number) = 12 then regexp_replace(trans_party_number, '(\d{3})(\d{3})(\d{3})(\d{3})', '(\2) \3-\4')
		when length(trans_party_number) = 10 then regexp_replace(trans_party_number, '(\d{2})(\d{4})(\d{4})', '(0\1) \2-\3')
		when length(trans_party_number) = 9 and left(trans_party_number,2) = '08' then regexp_replace(trans_party_number, '(\d{3})(\d{3})(\d{3})', '(\1) \2-\3') 
		when length(trans_party_number) = 9 and left(trans_party_number,2) != '08' then regexp_replace(trans_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3') 
		when length(trans_party_number) = 8 then regexp_replace(trans_party_number, '(\d{4})(\d{4})', '(003) \1-\2')
		when length(trans_party_number) = 7 then regexp_replace(trans_party_number, '(\d{2})(\d{5})', '\2')
		else trans_party_number
	end as answerpoint,
	case
  		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%122' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%123' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%212' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%312' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%412' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%512' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%612' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%712' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%812' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%912' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%142' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%143' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%814' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%122' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')	
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%123' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')	
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%212' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')	
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%312' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%412' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%512' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%612' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%712' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%812' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%912' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%142' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%143' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%814' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(calling_party_number) = 13 and left(calling_party_number,5) = '00601' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{3})(\d{4})', '(\2) \3-\4')
		when length(calling_party_number) = 12 and left(calling_party_number,5) = '00601' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{3})(\d{3})', '(\2) \3-\4')
		when length(calling_party_number) = 12 and left(calling_party_number,6) like '00608%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{3})(\d{3})', '(\2) \3-\4')
		when length(calling_party_number) = 12 and left(calling_party_number,5) like '0601%' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})', '(\2) \3-\4')
		when length(calling_party_number) = 12 and left(calling_party_number,5) like '0060%' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})', '(\2) \3-\4')
		when length(calling_party_number) = 12 and left(calling_party_number,5) not like '0060%' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{4})(\d{4})', '(\2) \3-\4')
		when length(calling_party_number) = 12 and left(calling_party_number,3) like '01%' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{4})(\d{4})', '(\2) \3-\4')
		when length(calling_party_number) = 11 and left(calling_party_number,3) like '01%' then regexp_replace(calling_party_number, '(\d{3})(\d{4})(\d{4})', '(\1) \2-\3') 
		when length(calling_party_number) = 11 and left(calling_party_number,3) = '008' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{3})(\d{4})', '(\2) \3-\4')
		when length(calling_party_number) = 11 and left(calling_party_number,3) = '003' then regexp_replace(calling_party_number, '(\d{3})(\d{4})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) like '01%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,2) = '03' then regexp_replace(calling_party_number, '(\d{2})(\d{4})(\d{4})', '(0\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,2) = '05' then regexp_replace(calling_party_number, '(\d{2})(\d{4})(\d{4})', '(0\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '003' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '002' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '004' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '005' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '006' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '007' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '009' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '044' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) like '08%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) like '06%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(calling_party_number) = 10 and left(calling_party_number,4) like '008%' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{3})(\d{3})', '(\2) \3-\4')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '03' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '04' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '05' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '06' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '07' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')
		when length(calling_party_number) = 9 and left(calling_party_number,2) like '08%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{3})', '(\1) \2-\3')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '09' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')		
		when length(calling_party_number) = 8 then regexp_replace(calling_party_number, '(\d{4})(\d{4})', '(003) \1-\2')
   		else calling_party_number
   	end as caller,
   	calling_party_number,
   	case
  		when length(calling_party_number) = 16 then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
  		when length(calling_party_number) = 15 then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 13 and left(calling_party_number,5) = '00601' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{3})(\d{4})', '\2')
		when length(calling_party_number) = 12 and left(calling_party_number,5) = '00601' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{3})(\d{3})', '\2')
		when length(calling_party_number) = 12 and left(calling_party_number,6) like '00608%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{3})(\d{3})', '\2\3')
		when length(calling_party_number) = 12 and left(calling_party_number,5) like '0601%' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})', '\2')
		when length(calling_party_number) = 12 and left(calling_party_number,4) like '0603%' then regexp_replace(calling_party_number, '(\d{2})(\d{2})(\d{4})(\d{4})', '0\2\3')		
		when length(calling_party_number) = 12 and left(calling_party_number,4) like '601%' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{4})(\d{4})', '\2')
		when length(calling_party_number) = 12 and left(calling_party_number,4) like '001%' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{4})(\d{4})', '\2')
		when length(calling_party_number) = 12 and left(calling_party_number,4) not like '601%' and left(calling_party_number,4) not like '001%' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{4})(\d{4})', '\2')
		when length(calling_party_number) = 12 and left(calling_party_number,3) like '001%' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{4})(\d{4})', '\2')
		when length(calling_party_number) = 11 and left(calling_party_number,3) like '01%' then regexp_replace(calling_party_number, '(\d{3})(\d{4})(\d{4})', '\1') 
		when length(calling_party_number) = 10 and left(calling_party_number,3) like '01%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1')
		when length(calling_party_number) = 10 and left(calling_party_number,3) not like '01%' then regexp_replace(calling_party_number, '(\d{2})(\d{4})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '03' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '04' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '05' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '06' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '07' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) like '08%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{3})', '\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '09' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 8 then regexp_replace(calling_party_number, '(\d{4})(\d{4})', '003\1')
   		else null
   	end as prefix,
	regexp_replace(start_date_time, '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})', '\1-\2-\3 \4:\5:\6') :: timestamp as startdatetime,
	to_char(regexp_replace(start_date_time, '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})', '\1-\2-\3 \4:\5:\6') :: timestamp,'Dy') as dy,
	to_char(regexp_replace(start_date_time, '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})', '\1-\2-\3 \4:\5:\6') :: timestamp,'hh24') :: numeric as hr,
	duration :: numeric duration,
	duration :: interval dduration,
    case when EXTRACT(EPOCH FROM duration :: interval) < 60 then 1 else 0 end as call60sec,
    call_cost :: numeric as call_cost_cent,
    (call_cost :: numeric * 0.01) as call_cost_rm,
    ct.call_type,
    case when st.call_flag = '0' then 'Answered Call' else 'Unanswered Call' end as call_status,
    sr.stop_reason,
   'TELLIN' as data_source          
from staging.tellin st 
LEFT JOIN ref.call_type ct on st.call_type :: numeric = ct.code 
LEFT JOIN ref.stop_reason sr on st.stop_reason :: numeric = sr.code

)

--insert into data.unsuccessful (
select
--	nextval('data.unsuccessful_id_seq') as id,
	t1.startdatetime,
	cb.customer_name,
	cb.account_num,
	t1.tollfree,
	t1.answerpoint,
	t1.caller,
	t1.dy,
	case 
		when t1.hr >= 0 and t1.hr <=2 then '12AM - 2AM'
		when t1.hr >= 3 and t1.hr <=4 then '3AM - 4AM'
		when t1.hr >= 5 and t1.hr <=6 then '5AM - 6AM'
		when t1.hr >= 7 and t1.hr <=8 then '7AM - 8AM'
		when t1.hr >= 9 and t1.hr <=10 then '9AM - 10AM'
		when t1.hr >= 11 and t1.hr <=12 then '11AM - 12PM'
		when t1.hr >= 13 and t1.hr <=14 then '1PM - 2PM'
		when t1.hr >= 15 and t1.hr <=16 then '3PM - 4PM'
		when t1.hr >= 17 and t1.hr <=18 then '5PM - 6PM'
		when t1.hr >= 19 and t1.hr <=20 then '7PM - 8PM'
		when t1.hr >= 21 and t1.hr <=22 then '9PM - 10PM'
		when t1.hr >= 23 and t1.hr <=24 then '11PM - 12AM'
		else null
	end as hr,
	t1.duration,
	t1.dduration,
	t1.call60sec,
	t1.call_cost_cent,
	t1.call_cost_rm,
	t1.call_type,
	t1.call_status,
	t1.stop_reason,
	CASE WHEN t1.call_type = 'International Call' THEN 'OTHER' ELSE p.area END AS area,
	CASE WHEN t1.call_type = 'International Call' THEN 'OTHER' ELSE p.state END AS state,
	CASE WHEN t1.call_type = 'International Call' THEN 'INT CALL' ELSE p.region END AS region,
	t1.data_source
FROM t1 
LEFT JOIN ref.custtbl cb on t1.called_party_number = cb.service_num
LEFT JOIN ref.prefix p on t1.prefix = p.prefix_range
where extract(year from t1.startdatetime) = 2020
order by startdatetime ASC
--);