-- ─── PROCEDURE→FUNCTION: workingtime_deletebeaconpoint ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_deletebeaconpoint(integer);
CREATE OR REPLACE FUNCTION public.workingtime_deletebeaconpoint(
    IN pointno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkingTime_BeaconPoints
	WHERE PointNo = workingtime_deletebeaconpoint.pointno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
