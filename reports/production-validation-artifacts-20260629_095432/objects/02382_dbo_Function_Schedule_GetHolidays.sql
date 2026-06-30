-- ─── FUNCTION: schedule_getholidays ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getholidays(character varying);
CREATE OR REPLACE FUNCTION public.schedule_getholidays(
    daytype character varying DEFAULT 'A'
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
    moddate text,
    col12 text
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
		ModDate,
		COALESCE(color, case when DayType = 'H' then 'e81919' else '383838' end) AS Color --0766f3
	FROM ScheduleHoliday
	WHERE ('A' = schedule_getholidays.daytype OR DayType = schedule_getholidays.daytype)
	ORDER BY DayType, IsHoliday Desc, IsLunar, SUBSTRING(CONVERT(VARCHAR(8),HolidayDate,112),5,4);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
