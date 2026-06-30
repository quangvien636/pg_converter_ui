-- ─── PROCEDURE→FUNCTION: workingtime_getandroiddevices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getandroiddevices();
CREATE OR REPLACE FUNCTION public.workingtime_getandroiddevices(
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	Query := 'SELECT DeviceNo, UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset ' +;
		'FROM WorkingTime_AndroidDevices  ' +
		'WHERE UserNo IN (' || ListOfUsers || ')'

	PERFORM query();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
