-- ─── PROCEDURE→FUNCTION: work_updatesetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updatesetting(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_updatesetting(
    IN settingno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkSettings SET
		ModUserNo = work_updatesetting.moduserno,
		ModDate = work_updatesetting.moddate,
		SettingValue = SettingValue
	WHERE SettingNo = work_updatesetting.settingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
