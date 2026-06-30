-- ─── PROCEDURE→FUNCTION: workingtime_updateholiday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updateholiday(integer, integer, date, character varying, boolean, boolean, boolean, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_updateholiday(
    IN userno integer,
    IN holidayno integer,
    IN holidaydate date,
    IN holidayname character varying,
    IN isrepeat boolean,
    IN islunar boolean,
    IN isholiday boolean DEFAULT TRUE,
    IN daytype character varying DEFAULT 'H'
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTimeHoliday
	HolidayDate := workingtime_updateholiday.holidaydate,;
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
