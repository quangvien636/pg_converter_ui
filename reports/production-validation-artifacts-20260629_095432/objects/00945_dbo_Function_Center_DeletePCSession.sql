-- ─── FUNCTION: center_deletepcsession ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deletepcsession();
CREATE OR REPLACE FUNCTION public.center_deletepcsession(
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_PCSessions WHERE SessionID = SessionID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
