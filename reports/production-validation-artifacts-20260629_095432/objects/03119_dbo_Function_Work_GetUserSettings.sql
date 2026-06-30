-- ─── FUNCTION: work_getusersettings ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getusersettings();
CREATE OR REPLACE FUNCTION public.work_getusersettings(
) RETURNS TABLE(
    userno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    permissionlevel text,
    isdisplay text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, RegUserNo, RegDate, ModUserNo, ModDate, PermissionLevel, IsDisplay
	FROM WorkUserSettings;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
