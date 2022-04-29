--DROP TABLE "ref".custtbl;

--CREATE TABLE "ref".custtbl (
--	account_num text NULL,
--	customer_name text NULL,
--	service_num text NULL
--);

--insert into "ref".custtbl  (
select
	account_num,
	SPLIT_PART(string_agg(customer_name, ' | '), ' | ', 1) AS customer_name,
	service_num

FROM ref.custprof
GROUP BY
	account_num,
	service_num
--); 

