-- ─── FUNCTION: schedule_getcalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendar(integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendar(
    calendarno integer
) RETURNS TABLE(
    calendarno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    type text,
    color text,
    uselevel text,
    description text,
    isnotinote text,
    isnotimail text,
    isnotisms text,
    isnotipopup text,
    notitimetype text,
    isfixed text,
    col17 text,
    col18 text,
    col19 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CalendarNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed, COALESCE(isall,0) isall
		, COALESCE(isDetail,0) isDetail
		, COALESCE(Detail,'') Detail
	FROM ScheduleCalendars 
	WHERE CalendarNo = schedule_getcalendar.calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
