-- ─── FUNCTION: drive_insertfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_insertfolder(integer, timestamp without time zone, timestamp without time zone, character varying, bigint, bigint, boolean);
CREATE OR REPLACE FUNCTION public.drive_insertfolder(
    userno integer,
    datecreated timestamp without time zone,
    datemodified timestamp without time zone,
    name character varying,
    length bigint,
    parentno bigint,
    isdeleted boolean
) RETURNS TABLE(
    folderno text
)
AS $function$
DECLARE
    folderno bigint;
BEGIN



	SELECT fno = R.FolderNo 
	FROM Drive_Folders  R
	WHERE R.ParentNo = drive_insertfolder.parentno AND R.IsDeleted = FALSE and r.Name = drive_insertfolder.name
	
	if(fno = 0)
	begin;
	INSERT INTO Drive_Folders (UserNo, DateCreated, DateModified, Name, Length, ParentNo, IsDeleted)
	VALUES (UserNo, DateCreated, DateModified, Name, Length, ParentNo, IsDeleted)


	SET FolderNo = lastval()

	RETURN QUERY
	SELECT FolderNo
	end
	else
	RETURN QUERY
	SELECT fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
