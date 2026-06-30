-- ─── FUNCTION: schedule_insertgooglecalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertgooglecalendar(integer, character varying, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_insertgooglecalendar(
    p_uno integer,
    p_title character varying,
    p_sd timestamp without time zone,
    p_ed timestamp without time zone
) RETURNS void
AS $function$
BEGIN


		INSERT INTO ScheduleGoogleContents(RegUserNo, RegDate, Title, StartDate, EndDate, ColorId)
		VALUES(p_uno, NOW(),p_title,p_sd, p_ed, p_color);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
