-- ─── PROCEDURE→FUNCTION: workingtime_updatelocation_enabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updatelocation_enabled(integer, boolean);
CREATE OR REPLACE FUNCTION public.workingtime_updatelocation_enabled(
    IN locationno integer,
    IN enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkingTime_Locations SET Enabled = workingtime_updatelocation_enabled.enabled WHERE LocationNo = workingtime_updatelocation_enabled.locationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
