-- ─── FUNCTION: center_deletemobilesession ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deletemobilesession();
CREATE OR REPLACE FUNCTION public.center_deletemobilesession(
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_MobileSessions WHERE SessionID = SessionId;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
