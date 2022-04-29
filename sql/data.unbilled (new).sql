-- ## State Region Summary Unbilled
-- ## Source is from RAW Successful CDR that has been processed by MEDIATION - but not categorized into Local Calls (MM) or STD Calls (BRM)
-- ## Source is from data.successful UNION ALL data.unsuccessful_19.05.2021

--drop table data.state_unbilled;

/*CREATE TABLE "data".unbilled (
	id SERIAL primary key NOT NULL,
	startdatetime timestamptz,
	customer_name text,
	account_num text,
	tollfree text,
	answerpoint text,
	caller text,
	dy text,
	hr text,
	duration numeric,
	dduration interval,
	call60sec numeric,
	call_cost_cent numeric,
	call_cost_rm numeric,
	call_type text,
	call_status text,
	stop_reason text,
	area text,
	state text,
	region text,
	data_source text
);*/


with a as 
(
--select * from data.successful s union all select * from data.unsuccessful u 
select *, 'Unbilled' as billing from data.successful s union all select *, 'Unbilled' as billing from data.unsuccessful u 
)	

--insert into data.unbilled
(
select 
	--nextval('data.unbilled_id_seq') as id,
	a.startdatetime,
	a.customer_name,
	a.account_num,
	a.tollfree,
	a.answerpoint,
	a.caller,
	a.dy,
	--a.hr, /*Need to update the hr range because incorrect in data source: staging.mmgmt & staging.obrm*/
	case 
		when a.startdatetime :: time between '00:00:00' and '02:59:59' then '12AM - 2AM'
		when a.startdatetime :: time between '03:00:00' and '05:59:59' then '3AM - 5AM'
		when a.startdatetime :: time between '06:00:00' and '08:59:59' then '6AM - 8AM'
		when a.startdatetime :: time between '09:00:00' and '11:59:59' then '9AM - 11AM'
		when a.startdatetime :: time between '12:00:00' and '14:59:59' then '12PM - 2PM'
		when a.startdatetime :: time between '15:00:00' and '17:59:59' then '3PM - 5PM'
		when a.startdatetime :: time between '18:00:00' and '20:59:59' then '6PM - 8PM'
		when a.startdatetime :: time between '21:00:00' and '23:59:59' then '9PM - 11PM'
		else null 
	end as hr,
	a.duration,
	a.dduration,
	a.call60sec,
	a.call_cost_cent,
	a.call_cost_rm,
	a.call_type,
	a.call_status,
	a.stop_reason,
	a.area,
	a.state,
	a.region,
	a.data_source,
	/*Below are 9 new added columns --> busy, no_answer, other, dur_range, reason, hr_id, state_id, dur_range_id & billing*/	
	case when a.stop_reason = 'Called Busy' then 1 else 0 end as busy,
	case when a.stop_reason = 'No Answer' then 1 else 0 end as no_answer,
	case when a.stop_reason not in ('Called Busy','No Answer','Answered Call') then 1 else 0 end as other,
	case 
		when a.duration >= 1 and a.duration <=15 then '1-15 seconds'
		when a.duration >= 16 and a.duration <=30 then '16-30 seconds'
		when a.duration >= 31 and a.duration <=45 then '31-45 seconds'
		when a.duration >= 46 and a.duration <=59 then '46-59 seconds'
		when a.duration >= 60 and a.duration <=120 then '1-2 minutes'
		when a.duration >120 then 'Greater than 2 minutes'
		else null 
	end as dur_range,	
	case 
		when a.stop_reason = 'Called Busy' then 'Busy'
		when a.stop_reason = 'No Answer' then 'No Answer'
		when a.stop_reason not in ('Called Busy','No Answer','Answered Call') then 'Other'
		else null 
	end as reason,	
	/*case 
		when hr = '12AM - 2AM' then 1
		when hr = '3AM - 5AM' then 2
		when hr = '6AM - 8AM' then 3
		when hr = '9AM - 11AM' then 4
		when hr = '12PM - 2PM' then 5
		when hr = '3PM - 5PM' then 6		
		when hr = '6PM - 8PM' then 7
		when hr = '9PM - 11PM' then 8
		else null 
	end as hr_id,*/
	case 
		when a.startdatetime :: time between '00:00:00' and '02:59:59' then 1
		when a.startdatetime :: time between '03:00:00' and '05:59:59' then 2
		when a.startdatetime :: time between '06:00:00' and '08:59:59' then 3
		when a.startdatetime :: time between '09:00:00' and '11:59:59' then 4
		when a.startdatetime :: time between '12:00:00' and '14:59:59' then 5
		when a.startdatetime :: time between '15:00:00' and '17:59:59' then 6
		when a.startdatetime :: time between '18:00:00' and '20:59:59' then 7
		when a.startdatetime :: time between '21:00:00' and '23:59:59' then 8
		else null 
	end as hr_id,
	case 
		when state = 'PERLIS' then 1
		when state = 'KEDAH' then 2
		when state = 'P.PINANG' then 3
		when state = 'PERAK' then 4
		when state = 'KELANTAN' then 5
		when state = 'TERENGGANU' then 6
		when state = 'PAHANG' then 7
		when state = 'SELANGOR' then 8
		when state = 'W.P KUALA LUMPUR' then 9
		when state = 'W.P PUTRAJAYA' then 10
		when state = 'W.P LABUAN' then 11
		when state = 'N. SEMBILAN' then 12 --'NEGERI SEMBILAN'
		when state = 'MELAKA' then 13
		when state = 'JOHOR' then 14
		when state = 'SABAH' then 15
		when state = 'SARAWAK' then 16
		when state = 'PERLIS / KEDAH / PULAU PINANG' then 17
		when state = 'KEDAH / PERLIS' then 18
		when state = 'KELANTAN / TERENGGANU / PAHANG' then 19
		when state = 'N. SEMBILAN / MELAKA' then 20
		when state = 'MOBILE' then 21
		when state = 'OTHERS' then 22
		else 23 
	end state_id,	
	case 
		when a.duration >= 1 and a.duration <=15 then 1
		when a.duration >= 16 and a.duration <=30 then 2
		when a.duration >= 31 and a.duration <=45 then 3
		when a.duration >= 46 and a.duration <=59 then 4
		when a.duration >= 60 and a.duration <=120 then 5
		when a.duration >120 then 6
		else 7
	end as dur_range_id,
	billing	
from a
--where extract(year from startdatetime) = 2018
--where extract(year from startdatetime) = 2021 --2020 
--order by startdatetime asc
limit 100
)


/*
select distinct reason from data.unbilled
------
reason
------
[NULL]
Other
Busy
No Answer
*/