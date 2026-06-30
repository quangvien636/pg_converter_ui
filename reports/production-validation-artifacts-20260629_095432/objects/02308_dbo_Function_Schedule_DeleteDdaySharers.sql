-- ─── FUNCTION: schedule_deleteddaysharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteddaysharers();
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysharers(
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleDdaySharers WHERE DdayNo = DdayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
