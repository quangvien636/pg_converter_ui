-- ─── FUNCTION: work_updatesetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updatesetting(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_updatesetting(
    settingno integer,
    moduserno integer,
    moddate timestamp without time zone
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
