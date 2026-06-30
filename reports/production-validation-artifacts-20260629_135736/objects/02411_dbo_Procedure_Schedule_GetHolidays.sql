-- ─── PROCEDURE→FUNCTION: schedule_getholidays ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getholidays(character varying);
CREATE OR REPLACE FUNCTION public.schedule_getholidays(
    IN daytype character varying DEFAULT 'A'
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
		ModDate,
		COALESCE(color, case when DayType = 'H' then 'e81919' else '383838' end) AS Color --0766f3
	FROM ScheduleHoliday
	WHERE ('A' = schedule_getholidays.daytype OR DayType = schedule_getholidays.daytype)
	ORDER BY DayType, IsHoliday Desc, IsLunar, SUBSTRING(CONVERT(VARCHAR(8),HolidayDate,112),5,4);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
