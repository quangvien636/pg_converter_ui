-- ─── PROCEDURE→FUNCTION: dday_insertandroiddevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_insertandroiddevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.dday_insertandroiddevice(
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


	DELETE FROM DDay_AndroidDevices WHERE UserNo = dday_insertandroiddevice.userno OR DeviceID = dday_insertandroiddevice.deviceid

	INSERT INTO DDay_AndroidDevices VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)


	DeviceNo := lastval();
	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
