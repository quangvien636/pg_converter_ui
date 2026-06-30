-- ─── FUNCTION: schedule_getresourcealarmsettingbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcealarmsettingbyuser(integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourcealarmsettingbyuser(
    userno integer
) RETURNS TABLE(
    col1 text,
    isemail text,
    isalarmi text,
    ispc text,
    ismobile text,
    timealarm text,
    isunuse text,
    iswebalarm text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	select /* TOP 1 */ UserNo,IsEmail,IsAlarmi,IsPC,IsMobile, TimeAlarm, IsUnuse , IsWebAlarm
	FROM  ScheduleResourceAlarmSetting;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
