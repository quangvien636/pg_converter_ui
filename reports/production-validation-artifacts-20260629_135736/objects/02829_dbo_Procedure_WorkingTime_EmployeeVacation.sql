-- ─── PROCEDURE→FUNCTION: workingtime_employeevacation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_employeevacation(timestamp without time zone, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.workingtime_employeevacation(
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT t.RegUserNo
			, CONVERT(varchar(10),t.CheckTimeFull,120) as ContentDate
			, t.TimeType
			, t.CheckTimeFull 
			, t.Remark
	FROM WorkingTime_Times t
	WHERE T.TimeType BETWEEN -6 and -1 AND T.CheckTimeFull BETWEEN p_from AND p_to AND T.RegUserNo = workingtime_employeevacation.p_uno
	ORDER BY T.CheckTimeFull asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
