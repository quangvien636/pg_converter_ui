-- ─── PROCEDURE→FUNCTION: schedule_insertviewcalendars ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertviewcalendars(integer, integer, timestamp without time zone, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_insertviewcalendars(
    IN userno integer,
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN istodoview boolean,
    IN isddayview boolean
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
