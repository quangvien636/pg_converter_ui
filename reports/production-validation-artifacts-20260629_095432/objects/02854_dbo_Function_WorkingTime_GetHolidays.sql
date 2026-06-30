-- ─── FUNCTION: workingtime_getholidays ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getholidays(character varying);
CREATE OR REPLACE FUNCTION public.workingtime_getholidays(
    p_type character varying DEFAULT 'A'
) RETURNS TABLE(
    holidayno text,
    holidaydate text,
    holidayname text,
    isrepeat text,
    islunar text,
    isholiday text,
    daytype text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		HolidayNo,
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
	FROM WorkingTimeHoliday
	WHERE ('A' = workingtime_getholidays.p_type OR DayType = workingtime_getholidays.p_type)
	ORDER BY DayType, IsHoliday Desc, IsLunar, HolidayDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
