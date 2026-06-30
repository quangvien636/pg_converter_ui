-- ─── PROCEDURE→FUNCTION: notice_insertiosdevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_insertiosdevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_insertiosdevice(
    IN userno integer,
    IN regdate timestamp without time zone,
    IN deviceid character varying,
    IN osversion character varying,
    IN notificationoptions character varying,
    IN timezoneoffset integer
) RETURNS SETOF record
AS $function$
DECLARE
    deviceno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	DELETE FROM Notice_IOSDevices WHERE UserNo = notice_insertiosdevice.userno OR DeviceID = notice_insertiosdevice.deviceid;
	INSERT INTO Notice_IOSDevices (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)
	VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)


	DeviceNo := lastval();
	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
