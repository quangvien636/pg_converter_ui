-- ─── FUNCTION: workingtime_updateautherkey ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateautherkey();
CREATE OR REPLACE FUNCTION public.workingtime_updateautherkey(
) RETURNS void
AS $function$
BEGIN


	update WorkingTime_AutherKey set value = p_Key;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
