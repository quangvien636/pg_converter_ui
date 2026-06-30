-- ─── PROCEDURE→FUNCTION: drive_movefolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_movefolder(bigint, bigint);
CREATE OR REPLACE FUNCTION public.drive_movefolder(
    IN f_id bigint,
    IN f_pr bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	UPDATE Drive_Folders SET ParentNo =drive_movefolder.f_pr   WHERE FolderNo = drive_movefolder.f_id

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
