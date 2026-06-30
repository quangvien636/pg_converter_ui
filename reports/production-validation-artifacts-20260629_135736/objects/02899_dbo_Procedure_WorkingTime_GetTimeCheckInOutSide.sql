-- ─── PROCEDURE→FUNCTION: workingtime_gettimecheckinoutside ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.workingtime_gettimecheckinoutside(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettimecheckinoutside(
    IN p_userno integer,
    IN p_day integer,
    IN p_workingno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT /* TOP 1 */  CheckTime, TimeOffset, WorkingDay, CheckTimeC, CheckTimeFull
	FROM WorkingTime_Times 
	WHERE TimeType = 2  AND RegUserNo = workingtime_gettimecheckinoutside.p_userno AND COALESCE(WorkingDayC,WorkingDay) = workingtime_gettimecheckinoutside.p_day AND WorkingNo < workingtime_gettimecheckinoutside.p_workingno
	and COALESCE(status,0) != 1
	AND WorkingNo > COALESCE((
							SELECT /* TOP 1 */ WorkingNo FROM WorkingTime_Times WHERE TimeType <> 2 AND WorkingNo < workingtime_gettimecheckinoutside.p_workingno 
							AND UserNo = workingtime_gettimecheckinoutside.p_userno  
						    ORDER BY WorkingNo DESC),0)
	ORDER BY WorkingNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
