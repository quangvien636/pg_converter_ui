-- ─── PROCEDURE→FUNCTION: drive_insertpemissioncommonfolders ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_insertpemissioncommonfolders(bigint, integer, integer);
CREATE OR REPLACE FUNCTION public.drive_insertpemissioncommonfolders(
    IN p_no bigint,
    IN p_uno integer,
    IN p_dno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Drive_PemissionCommonFolders (FolderNo, UserNo, DepartNo)
	VALUES (p_no, p_uno, p_dno)

	RETURN QUERY
	SELECT 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
