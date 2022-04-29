-- ## staging from cyn_ime
WITH c1 AS ( 
select
	regexp_replace(called_party_number, '(\d{4})(\d{2})(\d{4})', '\1-\2-\3') tollfree,
	calling_party_number, 
	length(calling_party_number) len,
	case 
		when length(trans_party_number) = 10 then regexp_replace(trans_party_number, '(\d{2})(\d{4})(\d{4})', '(6\1) \2-\3')
		when length(trans_party_number) = 9 then regexp_replace(trans_party_number, '(\d{2})(\d{3})(\d{4})', '(6\1) \2-\3') 
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
		when length(calling_party_number) = 12 and left(calling_party_number,4) like '006%' then regexp_replace(calling_party_number, '(\d{2})(\d{2})(\d{4})(\d{4})', '(\2) \3-\4')
		when length(calling_party_number) = 11 and left(calling_party_number,3) like '01%' then regexp_replace(calling_party_number, '(\d{3})(\d{4})(\d{4})', '(\1) \2-\3') 
		when length(calling_party_number) = 11 and left(calling_party_number,3) = '008' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{3})(\d{4})', '(\2) \3-\4')
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
   		else 'Unknown Caller' 
   	end as caller,
   	case
   		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%122' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%123' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%212' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%312' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%412' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%512' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%612' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%712' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%812' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%912' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%142' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%143' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 16 and left(calling_party_number,5) like '0%814' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%123' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%122' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%212' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%312' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%412' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%512' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%612' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%712' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%812' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%912' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%142' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%143' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 15 and left(calling_party_number,5) like '0%814' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 12 and left(calling_party_number,4) like '006%' then regexp_replace(calling_party_number, '(\d{2})(\d{2})(\d{4})(\d{4})', '\1\2')
		when length(calling_party_number) = 11 and left(calling_party_number,3) like '01%' then regexp_replace(calling_party_number, '(\d{3})(\d{4})(\d{4})', '\1') 
		when length(calling_party_number) = 11 and left(calling_party_number,3) = '008' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{3})(\d{4})', '\2\3')
		when length(calling_party_number) = 10 and left(calling_party_number,3) like '01%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1')
		when length(calling_party_number) = 10 and left(calling_party_number,2) = '03' then regexp_replace(calling_party_number, '(\d{2})(\d{4})(\d{4})', '0\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,2) = '04' then regexp_replace(calling_party_number, '(\d{2})(\d{4})(\d{4})', '0\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,2) = '05' then regexp_replace(calling_party_number, '(\d{2})(\d{4})(\d{4})', '0\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '002' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '003' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '004' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '005' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '006' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '007' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '009' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,3) = '044' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,3) like '08%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(calling_party_number) = 10 and left(calling_party_number,3) like '06%' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{4})', '0\1')
		when length(calling_party_number) = 10 and left(calling_party_number,4) like '008%' then regexp_replace(calling_party_number, '(\d{1})(\d{3})(\d{3})(\d{3})', '\2\3')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '03' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '04' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '05' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '06' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '07' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '08' then regexp_replace(calling_party_number, '(\d{3})(\d{3})(\d{3})', '\1\2')
		when length(calling_party_number) = 9 and left(calling_party_number,2) = '09' then regexp_replace(calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')		
		else null 
	end as prefix,
	regexp_replace(start_date_time, '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})', '\1-\2-\3 \4:\5:\6') :: timestamp as startdatetime,
	duration :: interval,
    case when EXTRACT(EPOCH FROM duration :: interval) < 60 then 'Calls < 60s' else 'Calls > 60s' end as "call60sec",
    (call_cost :: numeric) * 0.01 as call_cost_rm,
    ct.call_type,
    case when sc.call_flag = '0' then 'Answered Call' else 'Unanswered Call' end as call_status,
    sr.stop_reason,
   case when calling_party_number is not null then 'CYNIME' else null end as data_source    
        
from staging.cyn_ime sc
LEFT JOIN ref.call_type ct on sc.call_type :: numeric = ct.code 
LEFT JOIN ref.stop_reason sr on sc.stop_reason :: numeric = sr.code

)

select
	c1.tollfree,
	c1.answerpoint,
--	c1.calling_party_number,
--	c1.len,
	c1.caller,
	c1.startdatetime,
	to_char(c1.startdatetime,'Dy') as day,
	c1.duration,
	c1."call60sec",
	c1.call_cost_rm,
	c1.call_type,
	c1.call_status,
	c1.stop_reason,
	p.area,
	p.state,
	p.region,
	c1.data_source
FROM c1 
LEFT JOIN ref.prefix p on c1.prefix = p.prefix_range
LIMIT 1
;
