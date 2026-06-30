-- ─── FUNCTION: authority_getsitepermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_getsitepermission(integer);
CREATE OR REPLACE FUNCTION public.authority_getsitepermission(
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
	FROM Authority_SitePermissions
	WHERE UserNo = authority_getsitepermission.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
