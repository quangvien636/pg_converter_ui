-- ─── PROCEDURE→FUNCTION: schedule_getalarmsettingbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.schedule_getalarmsettingbyuser(integer);
CREATE OR REPLACE FUNCTION public.schedule_getalarmsettingbyuser(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	select /* TOP 1 */ UserNo,IsEmail,IsAlarmi,IsPC,IsMobile, TimeAlarm, IsUnuse,IsWebAlarm from  ScheduleAlarmSetting;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
