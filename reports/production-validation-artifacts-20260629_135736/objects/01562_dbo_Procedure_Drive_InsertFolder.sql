-- ─── PROCEDURE→FUNCTION: drive_insertfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_insertfolder(integer, timestamp without time zone, timestamp without time zone, character varying, bigint, bigint, boolean);
CREATE OR REPLACE FUNCTION public.drive_insertfolder(
    IN userno integer,
    IN datecreated timestamp without time zone,
    IN datemodified timestamp without time zone,
    IN name character varying,
    IN length bigint,
    IN parentno bigint,
    IN isdeleted boolean
) RETURNS SETOF record
AS $function$
DECLARE
    folderno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT  INTO  FROM Drive_Folders  R
	WHERE R.ParentNo = drive_insertfolder.parentno AND R.IsDeleted = FALSE and r.Name = drive_insertfolder.name
	
	if(fno = 0)
	begin;
	INSERT INTO Drive_Folders (UserNo, DateCreated, DateModified, Name, Length, ParentNo, IsDeleted)
	VALUES (UserNo, DateCreated, DateModified, Name, Length, ParentNo, IsDeleted)


	FolderNo := lastval();
	RETURN QUERY
	SELECT FolderNo
	END;
	ELSE
	RETURN QUERY
	SELECT fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
