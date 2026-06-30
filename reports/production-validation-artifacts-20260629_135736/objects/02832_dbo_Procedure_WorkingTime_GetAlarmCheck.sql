-- ─── PROCEDURE→FUNCTION: workingtime_getalarmcheck ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getalarmcheck();
CREATE OR REPLACE FUNCTION public.workingtime_getalarmcheck(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN







RETURN QUERY
select U.USERID
	   ,1 Type
	   ,U.USERNO
	   ,COALESCE(G.TIMEIN,c_cin) TimeCheck
	   ,COALESCE(G.SUN,0) SUN
	   ,COALESCE(G.MON,1) MON
	   ,COALESCE(G.TUE,1) TUE
	   ,COALESCE(G.WEN,1) WEN
	   ,COALESCE(G.THUR,1) THUR
	   ,COALESCE(G.FRI,1) FRI
	   ,COALESCE(G.SAT,0) SAT
	   ,v_type AS SenType
from Organization_Users u 
left JOIN WorkingTime_SettingGroup G ON G.iD = U.GROUPID
union all 
RETURN QUERY
select U.USERID
       ,3 type
	   ,U.USERNO
	   ,COALESCE(G.TIMEOUT, c_out) TimeCheck
	   ,COALESCE(G.SUN,0) SUN
	   ,COALESCE(G.MON,1) MON
	   ,COALESCE(G.TUE,1) TUE
	   ,COALESCE(G.WEN,1) WEN
	   ,COALESCE(G.THUR,1) THUR
	   ,COALESCE(G.FRI,1) FRI
	   ,COALESCE(G.SAT,0) SAT
	   ,v_type2 AS SenType
from Organization_Users u 
left JOIN WorkingTime_SettingGroup G ON G.iD = U.GROUPID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
