-- ─── FUNCTION: edms_insertdocumentpermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_insertdocumentpermission(bigint, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.edms_insertdocumentpermission(
    documentno bigint,
    userno integer,
    positionno integer,
    departno integer,
    permissionno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO EDMS_DocumentPermissions (DocumentNo, UserNo, PositionNo, DepartNo, PermissionNo)
	VALUES (DocumentNo, UserNo, PositionNo, DepartNo, PermissionNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
