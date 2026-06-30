-- ─── PROCEDURE→FUNCTION: workingtime_dellocationoutside ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_dellocationoutside(integer);
CREATE OR REPLACE FUNCTION public.workingtime_dellocationoutside(
    IN locationno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM WorkingTime_LocationsOutside
	WHERE LocationNo = workingtime_dellocationoutside.locationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
