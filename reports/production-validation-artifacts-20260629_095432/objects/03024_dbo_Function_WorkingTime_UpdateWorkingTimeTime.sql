-- ─── FUNCTION: workingtime_updateworkingtimetime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateworkingtimetime(integer, integer, character varying, character varying, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_updateworkingtimetime(
    p_wkno integer,
    p_wkday integer,
    p_time character varying,
    p_remark character varying,
    p_longtime double precision
) RETURNS TABLE(
    1 text
)
AS $function$
BEGIN


	UPDATE WorkingTime_Times
	SET WorkingDay = workingtime_updateworkingtimetime.p_wkday
		,CheckTime = workingtime_updateworkingtimetime.p_time
		,TimeCheckLong = workingtime_updateworkingtimetime.p_longtime
		,Remark = workingtime_updateworkingtimetime.p_remark
	WHERE WORKINGNO = workingtime_updateworkingtimetime.p_wkno

	EXEC public."WorkingTime_Times_v2_Update" p_WKNo =  workingtime_updateworkingtimetime.p_wkno, p_WKDay = workingtime_updateworkingtimetime.p_wkday, p_Time =  workingtime_updateworkingtimetime.p_time, p_Offset = p_Offset
	EXEC public."WorkingTime_Update_RequestCorrectionTime" p_WKNo =  workingtime_updateworkingtimetime.p_wkno,  p_Offset = p_Offset
	RETURN QUERY
	select 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
