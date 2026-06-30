-- ─── FUNCTION: schedule_insertviewcalendars ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertviewcalendars(integer, integer, timestamp without time zone, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_insertviewcalendars(
    userno integer,
    reguserno integer,
    regdate timestamp without time zone,
    istodoview boolean,
    isddayview boolean
) RETURNS void
AS $function$
BEGIN


	INSERT INTO ScheduleViewCalendars (UserNo, RegUserNo, RegDate, ModUserNo, ModDate,
		IsToDoView, IsDdayView, ViewCalendars)
	VALUES (UserNo, RegUserNo, RegDate, RegUserNo, RegDate,
		IsToDoView, IsDdayView, ViewCalendars);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
