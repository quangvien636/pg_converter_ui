-- ─── FUNCTION: workingtime_updateholiday ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateholiday(integer, integer, date, character varying, boolean, boolean, boolean, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_updateholiday(
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

	UPDATE WorkingTimeHoliday
	SET
		HolidayDate = workingtime_updateholiday.holidaydate,
		HolidayName = workingtime_updateholiday.holidayname,
		IsRepeat = workingtime_updateholiday.isrepeat,
		IsLunar = workingtime_updateholiday.islunar,
		IsHoliday = workingtime_updateholiday.isholiday,
		DayType = workingtime_updateholiday.daytype,
		ModUserNo = workingtime_updateholiday.userno,
		ModDate = NOW()
	WHERE HolidayNo = workingtime_updateholiday.holidayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
