-- ─── PROCEDURE→FUNCTION: drive_inserttrash ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_inserttrash(integer, timestamp without time zone, character varying, bigint, bigint);
CREATE OR REPLACE FUNCTION public.drive_inserttrash(
    IN userno integer,
    IN datedeleted timestamp without time zone,
    IN fullpath character varying,
    IN fileno bigint,
    IN folderno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    itemno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Drive_Trash (UserNo, DateDeleted, FullPath, FileNo, FolderNo)
	VALUES (UserNo, DateDeleted, FullPath, FileNo, FolderNo)


	ItemNo := lastval();
	RETURN QUERY
	SELECT ItemNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
