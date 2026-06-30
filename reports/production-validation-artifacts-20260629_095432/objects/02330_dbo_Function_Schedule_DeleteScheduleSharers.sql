-- ─── FUNCTION: schedule_deleteschedulesharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteschedulesharers(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteschedulesharers(
    scheduleno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleContentSharers WHERE ScheduleNo = schedule_deleteschedulesharers.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
