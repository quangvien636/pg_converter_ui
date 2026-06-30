-- ─── FUNCTION: work_getsettings ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getsettings();
CREATE OR REPLACE FUNCTION public.work_getsettings(
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
	FROM WorkSettings;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
