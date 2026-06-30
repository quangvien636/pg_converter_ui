-- ─── PROCEDURE→FUNCTION: workingtime_getlastbox ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.workingtime_getlastbox(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlastbox(
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ T.bno as No, T.bname as Name
	FROM WorkingTime_Times T
	WHERE T.bno IS NOT NULL AND T.bno <> 0 AND T.RegUserNo = workingtime_getlastbox.p_uno
	ORDER BY RegDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
