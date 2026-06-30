-- ─── FUNCTION: permission_updatepermissionlevel ───────────────────────────────
DROP FUNCTION IF EXISTS public.permission_updatepermissionlevel(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.permission_updatepermissionlevel(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone,
    level integer
) RETURNS void
AS $function$
BEGIN


	UPDATE PermissionLevels SET
		ModUserNo = permission_updatepermissionlevel.moduserno,
		ModDate = permission_updatepermissionlevel.moddate,
		Level = permission_updatepermissionlevel.level
	WHERE UserNo = permission_updatepermissionlevel.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
