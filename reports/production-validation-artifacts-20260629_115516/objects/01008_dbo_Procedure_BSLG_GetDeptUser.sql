-- ─── PROCEDURE→FUNCTION: bslg_getdeptuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getdeptuser(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getdeptuser(
    IN deptid character varying,
    IN lang character varying DEFAULT '1'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
--declare Deptid int
--set Deptid=1081

RETURN QUERY
select userid, 
 case when orgcd1=bslg_getdeptuser.deptid then posfg1  
	  when orgcd2=bslg_getdeptuser.deptid then posfg2
	  when orgcd3=bslg_getdeptuser.deptid then posfg3
	  when orgcd4=bslg_getdeptuser.deptid then posfg4
	  when orgcd5=bslg_getdeptuser.deptid then posfg5
	  when orgcd6=bslg_getdeptuser.deptid then posfg6
	  when orgcd7=bslg_getdeptuser.deptid then posfg7
 end as posfg,
 CASE Lang 
			WHEN '1' THEN UserNm1 
			WHEN '2' THEN CASE UserNm2 WHEN '' THEN UserNm2 ELSE UserNm2 END
			WHEN '3' THEN CASE UserNm3 WHEN '' THEN UserNm2 ELSE UserNm3 END
			WHEN '4' THEN CASE UserNm4 WHEN '' THEN UserNm2 ELSE UserNm4 END
			ELSE UserNm1
   End AS UserNm
  ,Deptid AS OrgCd
 from CMONUsers   A  
 LEFT OUTER JOIN CMONCommCd B   
 ON A.PosFg1 = B.CommCd AND B.ClassCd = 'C001'
where A.UseYn='Y' and (orgcd1=bslg_getdeptuser.deptid or orgcd2=bslg_getdeptuser.deptid or orgcd3=bslg_getdeptuser.deptid or orgcd4=bslg_getdeptuser.deptid or orgcd5=bslg_getdeptuser.deptid or orgcd6=bslg_getdeptuser.deptid or orgcd7=bslg_getdeptuser.deptid)
order by  B.SortOrd, A.UserGrade, A.RegYmd,UserNm;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
