-- ─── FUNCTION: schedule_deleteresource ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteresource(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresource(
    userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleResources
	SET
			ModUserNo = schedule_deleteresource.userno,
			ModDate = NOW(),
			Enabled = FALSE
	WHERE ResourceNo = ResourceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
