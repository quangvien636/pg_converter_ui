-- ─── PROCEDURE→FUNCTION: permission_updatepermissionlevel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.permission_updatepermissionlevel(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.permission_updatepermissionlevel(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN level integer
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
