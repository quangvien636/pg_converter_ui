-- ─── FUNCTION: workingtime_logoutuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_logoutuser();
CREATE OR REPLACE FUNCTION public.workingtime_logoutuser(
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Center_MobileSessions
	WHERE SessionID=sessionId;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
