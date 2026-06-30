-- ─── FUNCTION: main_insertdefaultusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_insertdefaultusersetting(character varying);
CREATE OR REPLACE FUNCTION public.main_insertdefaultusersetting(
    settingname character varying
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Main_DefaultUserSettings (SettingName, SettingValue)
	VALUES (SettingName, SettingValue);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
