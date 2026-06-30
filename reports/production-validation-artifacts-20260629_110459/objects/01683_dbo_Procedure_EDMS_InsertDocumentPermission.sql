-- ─── PROCEDURE→FUNCTION: edms_insertdocumentpermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edms_insertdocumentpermission(bigint, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.edms_insertdocumentpermission(
    IN documentno bigint,
    IN userno integer,
    IN positionno integer,
    IN departno integer,
    IN permissionno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO EDMS_DocumentPermissions (DocumentNo, UserNo, PositionNo, DepartNo, PermissionNo)
	VALUES (DocumentNo, UserNo, PositionNo, DepartNo, PermissionNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
