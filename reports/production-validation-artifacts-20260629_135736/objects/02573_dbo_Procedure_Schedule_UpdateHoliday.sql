-- ─── PROCEDURE→FUNCTION: schedule_updateholiday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateholiday(integer, integer, date, character varying, boolean, boolean, boolean, character varying);
CREATE OR REPLACE FUNCTION public.schedule_updateholiday(
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

	UPDATE ScheduleHoliday
	HolidayDate := schedule_updateholiday.holidaydate,;
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
