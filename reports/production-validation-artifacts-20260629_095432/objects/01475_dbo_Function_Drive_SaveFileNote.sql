-- ─── FUNCTION: drive_savefilenote ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_savefilenote(integer);
CREATE OR REPLACE FUNCTION public.drive_savefilenote(
    p_fno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Drive_Files SET NOTE = p_Note WHERE FILENO = drive_savefilenote.p_fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
