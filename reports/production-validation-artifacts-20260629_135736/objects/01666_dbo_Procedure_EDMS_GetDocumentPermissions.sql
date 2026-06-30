-- ─── PROCEDURE→FUNCTION: edms_getdocumentpermissions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edms_getdocumentpermissions(bigint);
CREATE OR REPLACE FUNCTION public.edms_getdocumentpermissions(
    IN documentno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT UserNo, PositionNo, DepartNo, PermissionNo
	FROM EDMS_DocumentPermissions
	WHERE DocumentNo = edms_getdocumentpermissions.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
