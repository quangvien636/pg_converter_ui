-- ─── PROCEDURE→FUNCTION: workingtime_locations_office_delete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_locations_office_delete(integer);
CREATE OR REPLACE FUNCTION public.workingtime_locations_office_delete(
    IN id integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM WorkingTime_Locations_Office
	WHERE id=workingtime_locations_office_delete.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
