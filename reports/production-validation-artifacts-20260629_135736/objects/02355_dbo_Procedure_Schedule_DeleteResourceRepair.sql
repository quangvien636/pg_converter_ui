-- ─── PROCEDURE→FUNCTION: schedule_deleteresourcerepair ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteresourcerepair();
CREATE OR REPLACE FUNCTION public.schedule_deleteresourcerepair(
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleResourcesRepair
	WHERE RepairNo = RepairNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
