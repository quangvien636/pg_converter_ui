-- ─── PROCEDURE→FUNCTION: center_getholidayforsaturdayandsunday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getholidayforsaturdayandsunday(integer);
CREATE OR REPLACE FUNCTION public.center_getholidayforsaturdayandsunday(
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT HolidayNo, ModUserNo, ModDate, HolidayType, HolidayDate, Lunar, Substitution, Title, Description
	FROM Center_Holidays
	WHERE GroupNo = center_getholidayforsaturdayandsunday.groupno AND HolidayType = 0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
