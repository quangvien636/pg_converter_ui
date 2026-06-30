-- ─── FUNCTION: schedule_updateschedulestartud ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateschedulestartud(date);
CREATE OR REPLACE FUNCTION public.schedule_updateschedulestartud(
    p_startdate date
) RETURNS void
AS $function$
BEGIN

	update ScheduleContents
	set StartDate = schedule_updateschedulestartud.p_startdate,
	OldScheduleNo = p_ScheduleNo
	WHERE ScheduleNo = p_scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
