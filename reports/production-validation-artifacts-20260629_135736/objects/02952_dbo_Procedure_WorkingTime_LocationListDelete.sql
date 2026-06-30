-- ─── PROCEDURE→FUNCTION: workingtime_locationlistdelete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_locationlistdelete(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_locationlistdelete(
    IN userno integer,
    IN id integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM WorkingTime_LocationList
	WHERE userno=workingtime_locationlistdelete.userno AND id=workingtime_locationlistdelete.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
