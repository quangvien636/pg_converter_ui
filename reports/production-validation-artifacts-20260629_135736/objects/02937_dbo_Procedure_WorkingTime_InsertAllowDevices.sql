-- ─── PROCEDURE→FUNCTION: workingtime_insertallowdevices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_insertallowdevices(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_insertallowdevices(
    IN departno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    allowdeviceno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	INSERT INTO WorkingTime_AllowDevices(DepartNo,UserNo,ContentAllow) VALUES (DepartNo,UserNo,ContentAllow)


	AllowDeviceNo := lastval();
	RETURN QUERY
	SELECT AllowDeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
