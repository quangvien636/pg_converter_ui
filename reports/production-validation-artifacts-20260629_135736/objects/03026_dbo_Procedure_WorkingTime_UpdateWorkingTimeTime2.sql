-- ─── PROCEDURE→FUNCTION: workingtime_updateworkingtimetime2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_updateworkingtimetime2(integer, integer, character varying, character varying, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_updateworkingtimetime2(
    IN p_wkno integer,
    IN p_wkday integer,
    IN p_time character varying,
    IN p_remark character varying,
    IN p_longtime double precision
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



   SELECT TimeOffset, TimeType INTO p_offset, p_ptype from WorkingTime_Times;
	UPDATE WorkingTime_Times
	WorkingDay := workingtime_updateworkingtimetime2.p_wkday;
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
