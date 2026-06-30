-- ─── FUNCTION: center_deletemobilesessioninfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deletemobilesessioninfo(integer);
CREATE OR REPLACE FUNCTION public.center_deletemobilesessioninfo(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_MobileSessions WHERE UserNo = center_deletemobilesessioninfo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
