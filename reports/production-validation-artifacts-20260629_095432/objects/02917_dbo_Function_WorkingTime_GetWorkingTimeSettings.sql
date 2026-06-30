-- ─── FUNCTION: workingtime_getworkingtimesettings ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimesettings();
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimesettings(
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
