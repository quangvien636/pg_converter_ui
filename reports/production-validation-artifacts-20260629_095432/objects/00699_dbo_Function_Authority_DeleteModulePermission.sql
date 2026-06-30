-- ─── FUNCTION: authority_deletemodulepermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_deletemodulepermission(integer);
CREATE OR REPLACE FUNCTION public.authority_deletemodulepermission(
    modulepermissionno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Authority_ModulePermission
	WHERE ModulePermissionNo = authority_deletemodulepermission.modulepermissionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
