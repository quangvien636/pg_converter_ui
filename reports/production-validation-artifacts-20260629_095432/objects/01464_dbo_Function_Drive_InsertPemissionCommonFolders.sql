-- ─── FUNCTION: drive_insertpemissioncommonfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_insertpemissioncommonfolders(bigint, integer, integer);
CREATE OR REPLACE FUNCTION public.drive_insertpemissioncommonfolders(
    p_no bigint,
    p_uno integer,
    p_dno integer
) RETURNS TABLE(
    1 text
)
AS $function$
BEGIN


	INSERT INTO Drive_PemissionCommonFolders (FolderNo, UserNo, DepartNo)
	VALUES (p_no, p_uno, p_dno)

	RETURN QUERY
	SELECT 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
