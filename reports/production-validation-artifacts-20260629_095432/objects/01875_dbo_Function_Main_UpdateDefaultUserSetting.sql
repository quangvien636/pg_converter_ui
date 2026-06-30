-- ─── FUNCTION: main_updatedefaultusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_updatedefaultusersetting(character varying);
CREATE OR REPLACE FUNCTION public.main_updatedefaultusersetting(
    settingname character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE Main_DefaultUserSettings SET SettingValue = SettingValue
	WHERE SettingName = main_updatedefaultusersetting.settingname

	update main_usersettings set firstprojectcode = SettingValue;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
