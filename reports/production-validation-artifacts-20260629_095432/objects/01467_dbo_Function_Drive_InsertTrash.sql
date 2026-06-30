-- ─── FUNCTION: drive_inserttrash ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_inserttrash(integer, timestamp without time zone, character varying, bigint, bigint);
CREATE OR REPLACE FUNCTION public.drive_inserttrash(
    userno integer,
    datedeleted timestamp without time zone,
    fullpath character varying,
    fileno bigint,
    folderno bigint
) RETURNS TABLE(
    itemno text
)
AS $function$
DECLARE
    itemno bigint;
BEGIN


	INSERT INTO Drive_Trash (UserNo, DateDeleted, FullPath, FileNo, FolderNo)
	VALUES (UserNo, DateDeleted, FullPath, FileNo, FolderNo)


	SET ItemNo = lastval()

	RETURN QUERY
	SELECT ItemNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
