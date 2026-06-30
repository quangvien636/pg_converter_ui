-- ─── FUNCTION: permission_getpermissionlevel ───────────────────────────────
DROP FUNCTION IF EXISTS public.permission_getpermissionlevel(integer);
CREATE OR REPLACE FUNCTION public.permission_getpermissionlevel(
    userno integer
) RETURNS TABLE(
    userno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    level text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, RegUserNo, RegDate, ModUserNo, ModDate, Level
	FROM PermissionLevels
	WHERE UserNo = permission_getpermissionlevel.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
