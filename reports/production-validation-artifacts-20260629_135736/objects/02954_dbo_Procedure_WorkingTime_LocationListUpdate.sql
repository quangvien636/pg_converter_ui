-- ─── PROCEDURE→FUNCTION: workingtime_locationlistupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_locationlistupdate(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_locationlistupdate(
    IN userno integer,
    IN id integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_LocationList
	name := name;
	WHERE id=workingtime_locationlistupdate.id AND userno=workingtime_locationlistupdate.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
