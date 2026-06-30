-- ─── PROCEDURE→FUNCTION: workingtime_recal ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_recal(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_recal(
    IN p_uno integer,
    IN p_start integer,
    IN p_end integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT T.*
	FROM WorkingTime_Times T 
	where T.TimeType = 3 
	and T.UserNo = workingtime_recal.p_uno AND T.WorkingDayC BETWEEN p_Start AND p_End
	ORDER BY t.CheckTimeFull ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
