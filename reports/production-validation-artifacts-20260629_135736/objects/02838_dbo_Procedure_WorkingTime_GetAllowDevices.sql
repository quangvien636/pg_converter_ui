-- ─── PROCEDURE→FUNCTION: workingtime_getallowdevices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getallowdevices();
CREATE OR REPLACE FUNCTION public.workingtime_getallowdevices(
) RETURNS SETOF record
AS $function$
DECLARE
    tableuser_allow table(
	userno int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO TABLEUSER_ALLOW
	PERFORM workingtime_getusernoallowdevice();
	RETURN QUERY
	SELECT w.* FROM WorkingTime_AllowDevices w inner join TABLEUSER_ALLOW t on w.UserNo = t.UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
