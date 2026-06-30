-- ─── FUNCTION: schedule_getgooglecontents ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getgooglecontents(integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_getgooglecontents(
    p_uno integer,
    p_sd timestamp without time zone,
    p_ed timestamp without time zone
) RETURNS TABLE(
    scheduleno serial,
    reguserno integer,
    regdate timestamp without time zone,
    title character varying(100),
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    colorid character varying(20)
)
AS $function$
BEGIN


		RETURN QUERY
		select * from ScheduleGoogleContents s where RegUserNo = schedule_getgooglecontents.p_uno and s.StartDate <= schedule_getgooglecontents.p_ed AND S.EndDate >= schedule_getgooglecontents.p_sd;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
