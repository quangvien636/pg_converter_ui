-- ─── PROCEDURE→FUNCTION: drive_deletefoldertrash ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_deletefoldertrash(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletefoldertrash(
    IN p_fno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	DELETE FROM Drive_Trash WHERE FolderNo = drive_deletefoldertrash.p_fno;
	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
