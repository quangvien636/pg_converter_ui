-- ─── PROCEDURE→FUNCTION: center_getholidaygroupnobyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.center_getholidaygroupnobyuser(integer);
CREATE OR REPLACE FUNCTION public.center_getholidaygroupnobyuser(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	GroupNo := (SELECT /* TOP 1 */ GroupNo FROM Center_HolidayGroups);
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
