-- ─── FUNCTION: permission_insertpermissionlevel ───────────────────────────────
DROP FUNCTION IF EXISTS public.permission_insertpermissionlevel(integer, integer, timestamp without time zone, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.permission_insertpermissionlevel(
    userno integer,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    level integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO PermissionLevels
	VALUES(UserNo, RegUserNo, RegDate, ModUserNo, ModDate, Level);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
