-- ─── FUNCTION: schedule_getalarmsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getalarmsetting();
CREATE OR REPLACE FUNCTION public.schedule_getalarmsetting(
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select /* TOP 1 */ IsEmail = IsEmail from ScheduleAlarmSetting where IsEmail = TRUE
	RETURN QUERY
	select /* TOP 1 */ IsAlarmi = IsAlarmi from ScheduleAlarmSetting where IsAlarmi = TRUE
	RETURN QUERY
	select /* TOP 1 */ IsPC = IsPC from ScheduleAlarmSetting where IsPC = TRUE
	RETURN QUERY
	select /* TOP 1 */ IsMobile = IsMobile from ScheduleAlarmSetting where IsMobile = TRUE
	set IsNotification = case when (COALESCE(IsEmail,0) = 1 or COALESCE(IsAlarmi,0) = 1 or COALESCE(IsPC,0) = 1 or COALESCE(IsMobile,0) = 1 ) then 1 else 0 end
	RETURN QUERY
	select COALESCE(IsEmail,0) as IsEmail,COALESCE(IsAlarmi,0) as IsAlarmi,COALESCE(IsPC,0) as IsPC, COALESCE(IsMobile,0) as IsMobile, COALESCE(isNotification,0) as IsNotification;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
