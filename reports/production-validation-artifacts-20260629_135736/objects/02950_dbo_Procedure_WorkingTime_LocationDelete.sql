-- ─── PROCEDURE→FUNCTION: workingtime_locationdelete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_locationdelete(integer);
CREATE OR REPLACE FUNCTION public.workingtime_locationdelete(
    IN locationno integer
) RETURNS void
AS $function$
BEGIN

   DELETE FROM WorkingTime_Locations
   WHERE LocationNo=workingtime_locationdelete.locationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
