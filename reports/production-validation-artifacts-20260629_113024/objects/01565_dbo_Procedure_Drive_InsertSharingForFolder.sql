-- ─── PROCEDURE→FUNCTION: drive_insertsharingforfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_insertsharingforfolder(bigint, integer, integer);
CREATE OR REPLACE FUNCTION public.drive_insertsharingforfolder(
    IN folderno bigint,
    IN userno integer,
    IN departno integer
) RETURNS SETOF record
AS $function$
DECLARE
    sharingno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Drive_SharingForFolders (FolderNo, UserNo, DepartNo)
	VALUES (FolderNo, UserNo, DepartNo)


	SharingNo := lastval();
	RETURN QUERY
	SELECT SharingNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
