-- ─── FUNCTION: drive_insertsharingforfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_insertsharingforfolder(bigint, integer, integer);
CREATE OR REPLACE FUNCTION public.drive_insertsharingforfolder(
    folderno bigint,
    userno integer,
    departno integer
) RETURNS TABLE(
    sharingno text
)
AS $function$
DECLARE
    sharingno bigint;
BEGIN


	INSERT INTO Drive_SharingForFolders (FolderNo, UserNo, DepartNo)
	VALUES (FolderNo, UserNo, DepartNo)


	SET SharingNo = lastval()

	RETURN QUERY
	SELECT SharingNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
