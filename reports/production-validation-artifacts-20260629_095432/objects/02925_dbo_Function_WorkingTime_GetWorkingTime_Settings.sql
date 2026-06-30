-- ─── FUNCTION: workingtime_getworkingtime_settings ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_settings();
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_settings(
) RETURNS TABLE(
    settingno text,
    settingvalue text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT SettingNo, SettingValue FROM WorkingTime_Settings;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
