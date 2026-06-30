-- ─── PROCEDURE→FUNCTION: main_insertdefaultusersetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_insertdefaultusersetting(character varying);
CREATE OR REPLACE FUNCTION public.main_insertdefaultusersetting(
    IN settingname character varying
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Main_DefaultUserSettings (SettingName, SettingValue)
	VALUES (SettingName, SettingValue);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
