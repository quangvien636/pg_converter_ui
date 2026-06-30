-- ─── FUNCTION: schedule_deleteschedulecontacts ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteschedulecontacts();
CREATE OR REPLACE FUNCTION public.schedule_deleteschedulecontacts(
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleContentsContacts WHERE ScheduleNo = ScheduleNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
