-- ─── PROCEDURE→FUNCTION: workingtime_deletelocation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_deletelocation();
CREATE OR REPLACE FUNCTION public.workingtime_deletelocation(
) RETURNS void
AS $function$
BEGIN

	DELETE FROM WorkingTime_Locations
	WHERE LocationNo = LocationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
