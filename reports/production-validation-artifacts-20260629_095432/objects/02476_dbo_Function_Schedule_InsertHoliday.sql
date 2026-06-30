-- ─── FUNCTION: schedule_insertholiday ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertholiday(date, character varying, boolean, boolean, boolean, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertholiday(
    holidaydate date,
    holidayname character varying,
    isrepeat boolean,
    islunar boolean,
    isholiday boolean DEFAULT TRUE,
    daytype character varying DEFAULT 'H'
) RETURNS void
AS $function$
BEGIN

	INSERT INTO ScheduleHoliday
	(
		HolidayDate,
		HolidayName,
		IsRepeat,
		IsLunar,
		IsHoliday,
		DayType,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate,
		color
	)
	VALUES
	(
		HolidayDate,
		HolidayName,
		IsRepeat,
		IsLunar,
		IsHoliday,
		DayType,
		UserNo,
		NOW(),
		UserNo,
		NOW(),
		p_color 
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
