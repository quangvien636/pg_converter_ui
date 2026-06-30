-- ─── FUNCTION: work_getusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getusersetting(integer);
CREATE OR REPLACE FUNCTION public.work_getusersetting(
    userno integer
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
	SELECT UserNo, RegUserNo, RegDate, ModUserNo, ModDate,
		PermissionLevel, IsDisplay
	FROM WorkUserSettings
	WHERE UserNo = work_getusersetting.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
