-- ─── FUNCTION: center_deletequickfunctions ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deletequickfunctions(integer);
CREATE OR REPLACE FUNCTION public.center_deletequickfunctions(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_QuickFunctions WHERE UserNo = center_deletequickfunctions.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
