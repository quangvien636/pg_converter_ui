-- ─── FUNCTION: drive_movefolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_movefolder(bigint, bigint);
CREATE OR REPLACE FUNCTION public.drive_movefolder(
    f_id bigint,
    f_pr bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	UPDATE Drive_Folders SET ParentNo =drive_movefolder.f_pr   WHERE FolderNo = drive_movefolder.f_id

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
