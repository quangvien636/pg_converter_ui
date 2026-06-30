-- ─── FUNCTION: drive_insertfile2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_insertfile2(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, bigint, bigint, boolean);
CREATE OR REPLACE FUNCTION public.drive_insertfile2(
    userno integer,
    datecreated timestamp without time zone,
    datemodified timestamp without time zone,
    dateaccessed timestamp without time zone,
    name character varying,
    length bigint,
    folderno bigint,
    isdeleted boolean
) RETURNS TABLE(
    fileno text
)
AS $function$
DECLARE
    fileno bigint;
BEGIN


	INSERT INTO Drive_Files (UserNo, DateCreated, DateModified, DateAccessed, Name, Length, FolderNo, IsDeleted, Note)
	VALUES (UserNo, DateCreated, DateModified, DateAccessed, Name, Length, FolderNo, IsDeleted, p_note)


	SET FileNo = lastval()

	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
