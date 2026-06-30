-- ─── FUNCTION: schedule_insertscheduleforoutlookentryid ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertscheduleforoutlookentryid(integer);
CREATE OR REPLACE FUNCTION public.schedule_insertscheduleforoutlookentryid(
    scheduleno integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO ScheduleContentsOutlook
	(
		UserNo,
		ScheduleNo,
		OutlookEntryID
	)
	VALUES
	(
		UserNo,
		ScheduleNo,
		OutlookEntryID
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
