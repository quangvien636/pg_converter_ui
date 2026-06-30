-- ─── PROCEDURE→FUNCTION: schedule_insertscheduleforoutlookentryid ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertscheduleforoutlookentryid(integer);
CREATE OR REPLACE FUNCTION public.schedule_insertscheduleforoutlookentryid(
    IN scheduleno integer
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
