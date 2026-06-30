-- ─── FUNCTION: work_getsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getsetting(integer);
CREATE OR REPLACE FUNCTION public.work_getsetting(
    settingno integer
) RETURNS TABLE(
    settingno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    settingvalue text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT SettingNo, RegUserNo, RegDate, ModUserNo, ModDate, SettingValue
	FROM WorkSettings
	WHERE SettingNo = work_getsetting.settingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
