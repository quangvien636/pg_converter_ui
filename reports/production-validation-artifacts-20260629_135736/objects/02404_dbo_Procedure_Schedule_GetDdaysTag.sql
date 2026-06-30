-- ─── PROCEDURE→FUNCTION: schedule_getddaystag ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getddaystag(integer);
CREATE OR REPLACE FUNCTION public.schedule_getddaystag(
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT UserNo, GroupNo, TagImageNo 
	FROM ScheduleDdaysTag
	WHERE UserNo = UserNo
	AND GroupNo = schedule_getddaystag.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
