-- ─── FUNCTION: schedule_getalarmsettingbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getalarmsettingbyuser(integer);
CREATE OR REPLACE FUNCTION public.schedule_getalarmsettingbyuser(
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
	select /* TOP 1 */ UserNo,IsEmail,IsAlarmi,IsPC,IsMobile, TimeAlarm, IsUnuse,IsWebAlarm from  ScheduleAlarmSetting;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
