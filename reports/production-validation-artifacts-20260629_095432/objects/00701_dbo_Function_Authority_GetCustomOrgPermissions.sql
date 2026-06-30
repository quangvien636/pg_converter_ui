-- ─── FUNCTION: authority_getcustomorgpermissions ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_getcustomorgpermissions();
CREATE OR REPLACE FUNCTION public.authority_getcustomorgpermissions(
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
	FROM Authority_CustomOrgPermissions;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
