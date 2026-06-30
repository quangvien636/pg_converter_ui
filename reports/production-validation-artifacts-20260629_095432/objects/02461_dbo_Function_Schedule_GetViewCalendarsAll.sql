-- ─── FUNCTION: schedule_getviewcalendarsall ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getviewcalendarsall(integer);
CREATE OR REPLACE FUNCTION public.schedule_getviewcalendarsall(
    userno integer
) RETURNS TABLE(
    userno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    istodoview text,
    isddayview text,
    iscompanyview text,
    ispersonalview text,
    isshareview text,
    isallview text,
    viewcalendars text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, RegUserNo, RegDate, ModUserNo, ModDate,
		IsToDoView, IsDdayView, IsCompanyView, IsPersonalView, IsShareView, IsAllView,  ViewCalendars
	FROM ScheduleViewCalendars
	WHERE UserNo = schedule_getviewcalendarsall.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
