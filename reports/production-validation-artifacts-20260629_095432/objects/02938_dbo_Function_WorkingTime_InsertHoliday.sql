-- ─── FUNCTION: workingtime_insertholiday ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_insertholiday(date, character varying, boolean, boolean, boolean, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_insertholiday(
    holidaydate date,
    holidayname character varying,
    isrepeat boolean,
    islunar boolean,
    isholiday boolean DEFAULT TRUE,
    daytype character varying DEFAULT 'H'
) RETURNS void
AS $function$
BEGIN

	INSERT INTO WorkingTimeHoliday
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
		ModDate
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
		NOW()
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
