-- ─── PROCEDURE→FUNCTION: workingtime_gettimereturnoutside ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.workingtime_gettimereturnoutside(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettimereturnoutside(
    IN userno integer,
    IN workingday integer,
    IN workingno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT /* TOP 1 */  CheckTime, TimeOffset, LunchStart, LunchEnd, IsAddLunch, BIn1, BOut1, BIn2, BOut2, IsB1, IsB2
	FROM WorkingTime_Times 
	WHERE TimeType = 4  AND RegUserNo = workingtime_gettimereturnoutside.userno AND WorkingDay =  workingtime_gettimereturnoutside.workingday AND WorkingNo > workingtime_gettimereturnoutside.workingno
	and COALESCE(status,0) != 1
	ORDER BY WorkingNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
