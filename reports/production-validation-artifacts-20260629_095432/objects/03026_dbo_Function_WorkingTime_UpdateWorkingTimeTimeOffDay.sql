-- ─── FUNCTION: workingtime_updateworkingtimetimeoffday ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateworkingtimetimeoffday(integer, integer, character varying, character varying, double precision, integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.workingtime_updateworkingtimetimeoffday(
    p_wkno integer,
    p_wkday integer,
    p_time character varying,
    p_remark character varying,
    p_longtime double precision,
    p_type integer,
    p_check integer,
    p_checkf timestamp without time zone
) RETURNS TABLE(
    1 text
)
AS $function$
BEGIN

	UPDATE WorkingTime_Times
	SET WorkingDay = workingtime_updateworkingtimetimeoffday.p_wkday
		,CheckTime = workingtime_updateworkingtimetimeoffday.p_time
		,TimeCheckLong = workingtime_updateworkingtimetimeoffday.p_longtime
		,Remark = workingtime_updateworkingtimetimeoffday.p_remark
		,TimeType = workingtime_updateworkingtimetimeoffday.p_type
		,CheckTimeC = workingtime_updateworkingtimetimeoffday.p_check
		,CheckTimeFull = workingtime_updateworkingtimetimeoffday.p_checkf
	WHERE WORKINGNO = workingtime_updateworkingtimetimeoffday.p_wkno

	EXEC public."WorkingTime_Times_v2_Update" p_WKNo =  workingtime_updateworkingtimetimeoffday.p_wkno, p_WKDay = workingtime_updateworkingtimetimeoffday.p_wkday, p_Time =  workingtime_updateworkingtimetimeoffday.p_time, p_Offset = 0
	RETURN QUERY
	select 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
