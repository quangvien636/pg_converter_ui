-- ─── PROCEDURE→FUNCTION: workingtime_updateworkingtimetimeoffday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_updateworkingtimetimeoffday(integer, integer, character varying, character varying, double precision, integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.workingtime_updateworkingtimetimeoffday(
    IN p_wkno integer,
    IN p_wkday integer,
    IN p_time character varying,
    IN p_remark character varying,
    IN p_longtime double precision,
    IN p_type integer,
    IN p_check integer,
    IN p_checkf timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	UPDATE WorkingTime_Times
	WorkingDay := workingtime_updateworkingtimetimeoffday.p_wkday;
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
