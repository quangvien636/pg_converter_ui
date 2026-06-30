-- ─── FUNCTION: drive_savefoldernote ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_savefoldernote(integer);
CREATE OR REPLACE FUNCTION public.drive_savefoldernote(
    p_fno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Drive_Folders  SET NOTE = p_Note WHERE FOLDERNO = drive_savefoldernote.p_fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
