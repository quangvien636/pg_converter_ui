-- ─── FUNCTION: schedule_updatescheduleud ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatescheduleud(date);
CREATE OR REPLACE FUNCTION public.schedule_updatescheduleud(
    p_enddate date
) RETURNS void
AS $function$
BEGIN

	update ScheduleContents
	set EndDate = schedule_updatescheduleud.p_enddate,
	OldScheduleNo = p_ScheduleNo
	WHERE ScheduleNo = p_scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
