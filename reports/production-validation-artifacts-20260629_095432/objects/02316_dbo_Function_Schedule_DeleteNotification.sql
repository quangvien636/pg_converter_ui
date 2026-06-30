-- ─── FUNCTION: schedule_deletenotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletenotification(bigint);
CREATE OR REPLACE FUNCTION public.schedule_deletenotification(
    scheduleno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Schedule_Notifications WHERE ScheduleNo = schedule_deletenotification.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
