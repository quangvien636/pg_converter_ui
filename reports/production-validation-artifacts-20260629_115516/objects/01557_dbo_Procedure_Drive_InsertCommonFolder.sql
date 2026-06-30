-- ─── PROCEDURE→FUNCTION: drive_insertcommonfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_insertcommonfolder(bigint, bigint);
CREATE OR REPLACE FUNCTION public.drive_insertcommonfolder(
    IN folderno bigint,
    IN maxlength bigint
) RETURNS SETOF record
AS $function$
DECLARE
    commonno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Drive_CommonFolders (FolderNo, MaxLength)
	VALUES (FolderNo, MaxLength)


	CommonNo := lastval();
	RETURN QUERY
	SELECT CommonNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
