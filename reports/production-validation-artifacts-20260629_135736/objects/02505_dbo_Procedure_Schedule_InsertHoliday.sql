-- ─── PROCEDURE→FUNCTION: schedule_insertholiday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertholiday(date, character varying, boolean, boolean, boolean, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertholiday(
    IN holidaydate date,
    IN holidayname character varying,
    IN isrepeat boolean,
    IN islunar boolean,
    IN isholiday boolean DEFAULT TRUE,
    IN daytype character varying DEFAULT 'H'
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
