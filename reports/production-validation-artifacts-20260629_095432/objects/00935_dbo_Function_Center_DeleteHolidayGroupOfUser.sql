-- ─── FUNCTION: center_deleteholidaygroupofuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deleteholidaygroupofuser(integer);
CREATE OR REPLACE FUNCTION public.center_deleteholidaygroupofuser(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_HolidayGroupOfUsers WHERE UserNo = center_deleteholidaygroupofuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
