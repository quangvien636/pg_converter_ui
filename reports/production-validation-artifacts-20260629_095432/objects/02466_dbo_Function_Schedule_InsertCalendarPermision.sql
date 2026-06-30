-- ─── FUNCTION: schedule_insertcalendarpermision ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertcalendarpermision(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertcalendarpermision(
    p_cno integer,
    p_uno integer DEFAULT 0,
    p_dno integer DEFAULT 0,
    p_pno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


		INSERT INTO ScheduleCalendarPermisions(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(p_cno, p_uNo,p_dNo,p_pNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
