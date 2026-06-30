-- ─── PROCEDURE→FUNCTION: edms_deletedocumentpermissions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edms_deletedocumentpermissions(bigint);
CREATE OR REPLACE FUNCTION public.edms_deletedocumentpermissions(
    IN documentno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM EDMS_DocumentPermissions
	WHERE DocumentNo = edms_deletedocumentpermissions.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
