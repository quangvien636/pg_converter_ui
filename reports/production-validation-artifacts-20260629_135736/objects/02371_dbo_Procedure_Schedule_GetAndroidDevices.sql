-- ─── PROCEDURE→FUNCTION: schedule_getandroiddevices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getandroiddevices();
CREATE OR REPLACE FUNCTION public.schedule_getandroiddevices(
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	Query := 'SELECT DeviceNo, UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset ' +;
		'FROM Schedule_AndroidDevices ' +
		'WHERE UserNo IN (' || ListOfUsers || ')'

	PERFORM query();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
