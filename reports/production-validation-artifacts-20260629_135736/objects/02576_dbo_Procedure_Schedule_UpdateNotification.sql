-- ─── PROCEDURE→FUNCTION: schedule_updatenotification ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatenotification(bigint, integer);
CREATE OR REPLACE FUNCTION public.schedule_updatenotification(
    IN notino bigint,
    IN notificationtype integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Schedule_Notifications SET
		NotificationType = schedule_updatenotification.notificationtype
	WHERE NotiNo = schedule_updatenotification.notino;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
