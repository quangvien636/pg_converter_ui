-- ─── PROCEDURE→FUNCTION: authority_deletemodulepermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.authority_deletemodulepermission(integer);
CREATE OR REPLACE FUNCTION public.authority_deletemodulepermission(
    IN modulepermissionno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Authority_ModulePermission
	WHERE ModulePermissionNo = authority_deletemodulepermission.modulepermissionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
