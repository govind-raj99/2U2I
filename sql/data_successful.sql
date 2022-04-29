--## CREATE and updating TABLE data.successful (bpo_ime and cyn_ime) for Raw Successful CDR - Near real time
--## Sources : staging.bpo_ime & staging.cyn_ime

--drop table data.successful;

--CREATE TABLE "data".successful (
--	id SERIAL primary key NOT NULL,
--	startdatetime timestamptz,
---	customer_name text,
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

with a as ( select *, 'BPO_IME' as data_source from staging.bpo_ime bi union all select *,'CYN_IME' as data_source from staging.cyn_ime ci),

b as (
select 
	a.called_party_number,
	regexp_replace(a.called_party_number, '(\d{4})(\d{2})(\d{4})', '\1-\2-\3') tollfree,
	case 
		when length(a.trans_party_number) = 10 then regexp_replace(trans_party_number, '(\d{2})(\d{4})(\d{4})', '(0\1) \2-\3')
		when length(a.trans_party_number) = 9 then regexp_replace(trans_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3') 
		when length(a.trans_party_number) = 8 then regexp_replace(trans_party_number, '(\d{4})(\d{4})', '(003) \1-\2')
		when length(a.trans_party_number) = 7 then regexp_replace(trans_party_number, '(\d{2})(\d{5})', '(0\1)-\2')
		else a.trans_party_number
	end as answerpoint,
	case
	  	when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%122' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%123' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%212' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%312' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%412' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%512' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%612' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%712' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%812' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%912' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%142' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%143' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%814' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%122' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')	
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%123' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')	
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%212' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')	
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%312' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%412' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%512' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%612' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%712' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%812' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%912' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%142' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%143' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%814' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '(\3) \4-\5')
		when length(a.calling_party_number) = 12 and left(a.calling_party_number,5) like '006%8' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{3})(\d{3})', '(\2) \3-\4')
		when length(a.calling_party_number) = 11 and left(a.calling_party_number,3) like '01%' then regexp_replace(a.calling_party_number, '(\d{3})(\d{4})(\d{4})', '(\1) \2-\3') 
		when length(a.calling_party_number) = 11 and left(a.calling_party_number,3) = '008' then regexp_replace(a.calling_party_number, '(\d{1})(\d{3})(\d{3})(\d{4})', '(\2) \3-\4')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) like '01%' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,2) = '03' then regexp_replace(a.calling_party_number, '(\d{2})(\d{4})(\d{4})', '(0\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,2) = '05' then regexp_replace(a.calling_party_number, '(\d{2})(\d{4})(\d{4})', '(0\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '003' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '002' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '004' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '005' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '006' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '007' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '009' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '044' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) like '08%' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) like '06%' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '(\1) \2-\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,4) like '008%' then regexp_replace(a.calling_party_number, '(\d{1})(\d{3})(\d{3})(\d{3})', '(\2) \3-\4')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '03' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '04' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '05' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '06' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '07' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) like '08%' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{3})', '(\1) \2-\3')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '09' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '(0\1) \2-\3')		
	   	else a.calling_party_number
	end as caller,
	case
	   	when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%122' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%123' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%212' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%312' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%412' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%512' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%612' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%712' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%812' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%912' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%142' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%143' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 16 and left(a.calling_party_number,5) like '0%814' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{4})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%123' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%122' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%212' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%312' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%412' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%512' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%612' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%712' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%812' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%912' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%142' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%143' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 15 and left(a.calling_party_number,5) like '0%814' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 12 and left(a.calling_party_number,5) like '006%8' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{3})(\d{3})', '\2\3')
		when length(a.calling_party_number) = 11 and left(a.calling_party_number,3) like '01%' then regexp_replace(a.calling_party_number, '(\d{3})(\d{4})(\d{4})', '\1') 
		when length(a.calling_party_number) = 11 and left(a.calling_party_number,3) = '008' then regexp_replace(a.calling_party_number, '(\d{1})(\d{3})(\d{3})(\d{4})', '\2\3')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) like '01%' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,2) = '03' then regexp_replace(a.calling_party_number, '(\d{2})(\d{4})(\d{4})', '0\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,2) = '04' then regexp_replace(a.calling_party_number, '(\d{2})(\d{4})(\d{4})', '0\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,2) = '05' then regexp_replace(a.calling_party_number, '(\d{2})(\d{4})(\d{4})', '0\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '002' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '003' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '004' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '005' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '006' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '007' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '009' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) = '044' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) like '08%' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '\1\2')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,3) like '06%' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{4})', '0\1')
		when length(a.calling_party_number) = 10 and left(a.calling_party_number,4) like '008%' then regexp_replace(a.calling_party_number, '(\d{1})(\d{3})(\d{3})(\d{3})', '\2\3')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '03' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '04' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '05' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '06' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '07' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '08' then regexp_replace(a.calling_party_number, '(\d{3})(\d{3})(\d{3})', '\1\2')
		when length(a.calling_party_number) = 9 and left(a.calling_party_number,2) = '09' then regexp_replace(a.calling_party_number, '(\d{2})(\d{3})(\d{4})', '0\1\2')		
		else null 
	end as prefix,
	regexp_replace(a.start_date_time, '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})', '\1-\2-\3 \4:\5:\6') :: timestamp as startdatetime,
	to_char(regexp_replace(a.start_date_time, '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})', '\1-\2-\3 \4:\5:\6') :: timestamp,'Dy') as dy,
	to_char(regexp_replace(a.start_date_time, '(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})', '\1-\2-\3 \4:\5:\6') :: timestamp,'hh24') :: numeric as hr,
	a.duration :: numeric duration,
	a.duration :: interval dduration,
	case when EXTRACT(EPOCH FROM a.duration :: interval) < 60 then 1 else 0 end as "call60sec",
	a.call_cost :: numeric as call_cost_cent,
	(a.call_cost :: numeric * 0.01) as call_cost_rm,
	a.call_type :: numeric,
	case when a.call_flag = '0' then 'Answered Call' else 'Unanswered Call' end as call_status,
	a.stop_reason :: numeric,
	a.data_source
from a 
)

insert into data.successful (
select 
	nextval('data.successful_id_seq') as id,
	b.startdatetime,
	cb.customer_name,
	cb.account_num,
	b.tollfree,
	b.answerpoint,
	b.caller,	
	b.dy,
	case 
		when b.hr >= 0 and b.hr <=2 then '12AM - 2AM'
		when b.hr >= 3 and b.hr <=4 then '3AM - 4AM'
		when b.hr >= 5 and b.hr <=6 then '5AM - 6AM'
		when b.hr >= 7 and b.hr <=8 then '7AM - 8AM'
		when b.hr >= 9 and b.hr <=10 then '9AM - 10AM'
		when b.hr >= 11 and b.hr <=12 then '11AM - 12PM'
		when b.hr >= 13 and b.hr <=14 then '1PM - 2PM'
		when b.hr >= 15 and b.hr <=16 then '3PM - 4PM'
		when b.hr >= 17 and b.hr <=18 then '5PM - 6PM'
		when b.hr >= 19 and b.hr <=20 then '7PM - 8PM'
		when b.hr >= 21 and b.hr <=22 then '9PM - 10PM'
		when b.hr >= 23 and b.hr <=24 then '11PM - 12AM'
		else null
	end as hr,
	b.duration,
	b.dduration,
	b.call60sec,
	b.call_cost_cent,
	b.call_cost_rm,
	ct.call_type,
	b.call_status,
	sr.stop_reason,
	p.area,
	p.state,
	p.region,
	b.data_source
FROM b 
left JOIN ref.call_type ct on b.call_type :: numeric = ct.code
left JOIN ref.stop_reason sr on b.stop_reason :: numeric = sr.code
left JOIN ref.custtbl cb on b.called_party_number = cb.service_num
left JOIN ref.prefix p on b.prefix = p.prefix_range
where extract(year from startdatetime) = 2018 

);