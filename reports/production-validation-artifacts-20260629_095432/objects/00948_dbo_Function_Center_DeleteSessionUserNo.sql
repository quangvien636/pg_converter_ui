-- ─── FUNCTION: center_deletesessionuserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deletesessionuserno(integer);
CREATE OR REPLACE FUNCTION public.center_deletesessionuserno(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_Sessions WHERE UserNo = center_deletesessionuserno.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
