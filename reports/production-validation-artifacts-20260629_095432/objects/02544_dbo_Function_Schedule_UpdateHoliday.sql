-- ─── FUNCTION: schedule_updateholiday ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateholiday(integer, integer, date, character varying, boolean, boolean, boolean, character varying);
CREATE OR REPLACE FUNCTION public.schedule_updateholiday(
    userno integer,
    holidayno integer,
    holidaydate date,
    holidayname character varying,
    isrepeat boolean,
    islunar boolean,
    isholiday boolean DEFAULT TRUE,
    daytype character varying DEFAULT 'H'
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleHoliday
	SET
		HolidayDate = schedule_updateholiday.holidaydate,
		HolidayName = schedule_updateholiday.holidayname,
		IsRepeat = schedule_updateholiday.isrepeat,
		IsLunar = schedule_updateholiday.islunar,
		IsHoliday = schedule_updateholiday.isholiday,
		DayType = schedule_updateholiday.daytype,
		ModUserNo = schedule_updateholiday.userno,
		ModDate = NOW(),
		color = p_color
	WHERE HolidayNo = schedule_updateholiday.holidayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
