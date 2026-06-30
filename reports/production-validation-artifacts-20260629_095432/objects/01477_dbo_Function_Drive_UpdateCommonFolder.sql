-- ─── FUNCTION: drive_updatecommonfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_updatecommonfolder(bigint, bigint);
CREATE OR REPLACE FUNCTION public.drive_updatecommonfolder(
    commonno bigint,
    maxlength bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	UPDATE Drive_CommonFolders SET MaxLength = drive_updatecommonfolder.maxlength
	WHERE CommonNo = drive_updatecommonfolder.commonno

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
