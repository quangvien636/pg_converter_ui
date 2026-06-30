-- ─── PROCEDURE→FUNCTION: dday_getnotifications ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_getnotifications(bigint);
CREATE OR REPLACE FUNCTION public.dday_getnotifications(
    IN dayno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT NotiNo, NotificationType, NotificationTime
	FROM DDay_Notifications WHERE DayNo = dday_getnotifications.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
