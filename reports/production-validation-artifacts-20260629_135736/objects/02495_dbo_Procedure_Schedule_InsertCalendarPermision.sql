-- ─── PROCEDURE→FUNCTION: schedule_insertcalendarpermision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertcalendarpermision(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertcalendarpermision(
    IN p_cno integer,
    IN p_uno integer DEFAULT 0,
    IN p_dno integer DEFAULT 0,
    IN p_pno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


		INSERT INTO ScheduleCalendarPermisions(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(p_cno, p_uNo,p_dNo,p_pNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
