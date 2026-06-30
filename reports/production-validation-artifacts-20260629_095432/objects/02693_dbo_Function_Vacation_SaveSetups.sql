-- ─── FUNCTION: vacation_savesetups ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_savesetups(boolean);
CREATE OR REPLACE FUNCTION public.vacation_savesetups(
    p_vl boolean
) RETURNS void
AS $function$
BEGIN

	update Vacation_Setups
	set val = vacation_savesetups.p_vl;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
