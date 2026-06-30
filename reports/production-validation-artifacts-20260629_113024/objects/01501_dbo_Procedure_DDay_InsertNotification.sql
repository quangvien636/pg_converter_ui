-- ─── PROCEDURE→FUNCTION: dday_insertnotification ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_insertnotification(bigint, integer);
CREATE OR REPLACE FUNCTION public.dday_insertnotification(
    IN dayno bigint,
    IN notificationtype integer
) RETURNS SETOF record
AS $function$
DECLARE
    notino bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO DDay_Notifications (DayNo, NotificationType, NotificationTime)
	VALUES (DayNo, NotificationType, NotificationTime)


	NotiNo := lastval();
	RETURN QUERY
	SELECT NotiNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
