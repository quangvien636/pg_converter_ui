-- ─── FUNCTION: schedule_deleteddaysrepeatall ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteddaysrepeatall();
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysrepeatall(
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleDdaysRepeat 
	WHERE DdayNo = DdayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
