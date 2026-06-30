-- ─── FUNCTION: main_getdefaultusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getdefaultusersetting();
CREATE OR REPLACE FUNCTION public.main_getdefaultusersetting(
) RETURNS TABLE(
    settingvalue text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT SettingValue
	FROM Main_DefaultUserSettings
	WHERE SettingName = SettingName;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
