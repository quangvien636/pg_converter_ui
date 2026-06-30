-- ─── FUNCTION: drive_deletefile ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deletefile(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletefile(
    fileno bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	DELETE FROM Drive_Files WHERE FileNo = drive_deletefile.fileno

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
