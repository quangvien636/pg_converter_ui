-- ─── FUNCTION: drive_movefile ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_movefile(character varying);
CREATE OR REPLACE FUNCTION public.drive_movefile(
    p_fino character varying
) RETURNS void
AS $function$
BEGIN

	

	EXECUTE (SQL);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
