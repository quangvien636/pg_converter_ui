-- ─── FUNCTION: schedule_deludscheduleud ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deludscheduleud(integer);
CREATE OR REPLACE FUNCTION public.schedule_deludscheduleud(
    p_no integer
) RETURNS void
AS $function$
BEGIN




	UPDATE ScheduleContentUds SET
		IsDelete = TRUE
		
		
	WHERE ScheduleNo = schedule_deludscheduleud.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
