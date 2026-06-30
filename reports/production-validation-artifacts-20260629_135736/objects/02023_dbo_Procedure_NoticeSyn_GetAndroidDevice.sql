-- ─── PROCEDURE→FUNCTION: noticesyn_getandroiddevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getandroiddevice(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT DeviceNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset
	FROM NoticeSyn_AndroidDevices
	WHERE UserNo = noticesyn_getandroiddevice.userno
	
END;
-----------------------------------------------//////////////////////////////////---------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
