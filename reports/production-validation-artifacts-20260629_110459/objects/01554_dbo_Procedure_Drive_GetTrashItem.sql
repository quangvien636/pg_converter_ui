-- ─── PROCEDURE→FUNCTION: drive_gettrashitem ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_gettrashitem(bigint);
CREATE OR REPLACE FUNCTION public.drive_gettrashitem(
    IN itemno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ItemNo, UserNo, DateDeleted, FullPath, FileNo, FolderNo
	FROM Drive_Trash
	WHERE ItemNo = drive_gettrashitem.itemno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
