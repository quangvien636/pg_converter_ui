-- ─── PROCEDURE→FUNCTION: workingtime_delworkingtime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_delworkingtime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_delworkingtime(
    IN workingno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkingTime_Times WHERE WorkingNo = workingtime_delworkingtime.workingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
