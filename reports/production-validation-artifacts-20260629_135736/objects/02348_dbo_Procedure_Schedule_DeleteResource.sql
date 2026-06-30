-- ─── PROCEDURE→FUNCTION: schedule_deleteresource ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteresource(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresource(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleResources
	ModUserNo := schedule_deleteresource.userno,;
			ModDate = NOW(),
			Enabled = FALSE
	WHERE ResourceNo = ResourceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
