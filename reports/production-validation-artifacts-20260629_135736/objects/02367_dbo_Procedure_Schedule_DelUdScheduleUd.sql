-- ─── PROCEDURE→FUNCTION: schedule_deludscheduleud ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deludscheduleud(integer);
CREATE OR REPLACE FUNCTION public.schedule_deludscheduleud(
    IN p_no integer
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
