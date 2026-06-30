-- ─── FUNCTION: authority_getsitepermissions ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_getsitepermissions();
CREATE OR REPLACE FUNCTION public.authority_getsitepermissions(
) RETURNS TABLE(
    userno text,
    moduserno text,
    moddate text,
    permissiontype text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, ModUserNo, ModDate, PermissionType
	FROM Authority_SitePermissions;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
