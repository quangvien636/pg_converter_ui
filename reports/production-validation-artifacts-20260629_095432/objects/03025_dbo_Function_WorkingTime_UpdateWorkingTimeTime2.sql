-- ─── FUNCTION: workingtime_updateworkingtimetime2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateworkingtimetime2(integer, integer, character varying, character varying, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_updateworkingtimetime2(
    p_wkno integer,
    p_wkday integer,
    p_time character varying,
    p_remark character varying,
    p_longtime double precision
) RETURNS TABLE(
    col1 text,
    col2 text
)
AS $function$
BEGIN



   select p_Offset = TimeOffset, p_ptype = TimeType  from WorkingTime_Times;
	UPDATE WorkingTime_Times
	SET WorkingDay = workingtime_updateworkingtimetime2.p_wkday
		,CheckTime = workingtime_updateworkingtimetime2.p_time
		,TimeCheckLong = workingtime_updateworkingtimetime2.p_longtime
		,Remark = workingtime_updateworkingtimetime2.p_remark
	WHERE WORKINGNO = workingtime_updateworkingtimetime2.p_wkno

	EXEC public."WorkingTime_Times_v2_Update" p_WKNo =  workingtime_updateworkingtimetime2.p_wkno, p_WKDay = workingtime_updateworkingtimetime2.p_wkday, p_Time =  workingtime_updateworkingtimetime2.p_time, p_Offset = p_Offset
	RETURN QUERY
	select p_ptype;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
