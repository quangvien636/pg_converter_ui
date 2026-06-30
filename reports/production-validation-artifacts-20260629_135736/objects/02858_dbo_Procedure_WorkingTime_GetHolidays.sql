-- ─── PROCEDURE→FUNCTION: workingtime_getholidays ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getholidays(character varying);
CREATE OR REPLACE FUNCTION public.workingtime_getholidays(
    IN p_type character varying DEFAULT 'A'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
		HolidayNo,
		HolidayDate,
		HolidayName,
		IsRepeat,
		IsLunar,
		IsHoliday,
		DayType,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate
	FROM WorkingTimeHoliday
	WHERE ('A' = workingtime_getholidays.p_type OR DayType = workingtime_getholidays.p_type)
	ORDER BY DayType, IsHoliday Desc, IsLunar, HolidayDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
