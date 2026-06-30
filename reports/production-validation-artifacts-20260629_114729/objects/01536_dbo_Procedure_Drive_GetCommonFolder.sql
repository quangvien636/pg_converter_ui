-- ─── PROCEDURE→FUNCTION: drive_getcommonfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_getcommonfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getcommonfolder(
    IN commonno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT CF.CommonNo, CF.MaxLength, CF.FolderNo, F.DateCreated, F.DateModified, F.Name, F.Length, F.ParentNo, F.IsDeleted
	FROM Drive_CommonFolders CF
	INNER JOIN Drive_Folders F ON F.FolderNo = CF.FolderNo
	WHERE CF.CommonNo = drive_getcommonfolder.commonno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
