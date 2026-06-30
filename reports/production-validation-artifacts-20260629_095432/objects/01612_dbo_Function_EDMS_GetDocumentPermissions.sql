-- ─── FUNCTION: edms_getdocumentpermissions ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getdocumentpermissions(bigint);
CREATE OR REPLACE FUNCTION public.edms_getdocumentpermissions(
    documentno bigint
) RETURNS TABLE(
    userno text,
    positionno text,
    departno text,
    permissionno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, PositionNo, DepartNo, PermissionNo
	FROM EDMS_DocumentPermissions
	WHERE DocumentNo = edms_getdocumentpermissions.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
