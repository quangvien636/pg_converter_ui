-- ─── FUNCTION: schedule_deleteresourcerepair ───────────────────────────────
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
