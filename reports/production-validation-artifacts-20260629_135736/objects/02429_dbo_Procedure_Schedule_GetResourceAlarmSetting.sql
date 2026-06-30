-- ─── PROCEDURE→FUNCTION: schedule_getresourcealarmsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.schedule_getresourcealarmsetting();
CREATE OR REPLACE FUNCTION public.schedule_getresourcealarmsetting(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select /* TOP 1 */ IsEmail = IsEmail from public."ScheduleResourceAlarmSetting" where IsEmail = TRUE
	RETURN QUERY
	select /* TOP 1 */ IsAlarmi = IsAlarmi from ScheduleResourceAlarmSetting where IsAlarmi = TRUE
	RETURN QUERY
	select /* TOP 1 */ IsPC = IsPC from ScheduleResourceAlarmSetting where IsPC = TRUE
	RETURN QUERY
	select /* TOP 1 */ IsMobile = IsMobile from ScheduleResourceAlarmSetting where IsMobile = TRUE
	IsNotification := case when (COALESCE(IsEmail,0) = 1 or COALESCE(IsAlarmi,0) = 1 or COALESCE(IsPC,0) = 1 or COALESCE(IsMobile,0) = 1 ) then 1 else 0 end;
	RETURN QUERY
	select COALESCE(IsEmail,0) as IsEmail,COALESCE(IsAlarmi,0) as IsAlarmi,COALESCE(IsPC,0) as IsPC, COALESCE(IsMobile,0) as IsMobile, COALESCE(isNotification,0) as IsNotification;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
