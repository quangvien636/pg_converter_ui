-- ─── FUNCTION: schedule_getviewcalendars ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getviewcalendars(integer);
CREATE OR REPLACE FUNCTION public.schedule_getviewcalendars(
    userno integer
) RETURNS TABLE(
    userno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    istodoview text,
    isddayview text,
    viewcalendars text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, RegUserNo, RegDate, ModUserNo, ModDate,
		IsToDoView, IsDdayView, ViewCalendars
	FROM ScheduleViewCalendars
	WHERE UserNo = schedule_getviewcalendars.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
