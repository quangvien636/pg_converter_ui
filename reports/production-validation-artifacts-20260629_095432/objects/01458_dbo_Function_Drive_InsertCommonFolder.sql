-- ─── FUNCTION: drive_insertcommonfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_insertcommonfolder(bigint, bigint);
CREATE OR REPLACE FUNCTION public.drive_insertcommonfolder(
    folderno bigint,
    maxlength bigint
) RETURNS TABLE(
    commonno text
)
AS $function$
DECLARE
    commonno bigint;
BEGIN


	INSERT INTO Drive_CommonFolders (FolderNo, MaxLength)
	VALUES (FolderNo, MaxLength)


	SET CommonNo = lastval()

	RETURN QUERY
	SELECT CommonNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
