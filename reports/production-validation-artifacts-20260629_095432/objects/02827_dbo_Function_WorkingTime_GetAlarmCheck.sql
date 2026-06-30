-- ─── FUNCTION: workingtime_getalarmcheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getalarmcheck();
CREATE OR REPLACE FUNCTION public.workingtime_getalarmcheck(
) RETURNS TABLE(
    userid text,
    col2 text,
    userno text,
    col4 text,
    col5 text,
    col6 text,
    col7 text,
    col8 text,
    col9 text,
    col10 text,
    col11 text,
    sentype text
)
AS $function$
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
