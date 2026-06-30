-- ─── FUNCTION: authority_getcustomorgpermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_getcustomorgpermission(integer);
CREATE OR REPLACE FUNCTION public.authority_getcustomorgpermission(
    userno integer
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
	FROM Authority_CustomOrgPermissions
	WHERE UserNo = authority_getcustomorgpermission.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
