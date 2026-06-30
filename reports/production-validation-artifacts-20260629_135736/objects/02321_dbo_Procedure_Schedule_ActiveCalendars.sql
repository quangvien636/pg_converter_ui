-- ─── PROCEDURE→FUNCTION: schedule_activecalendars ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_activecalendars(integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_activecalendars(
    IN typecalendar integer,
    IN isactive boolean
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleCalendars 
	IsActive := schedule_activecalendars.isactive;
	WHERE Type=schedule_activecalendars.typecalendar

	UPDATE ScheduleCalendarType
	IsActive := schedule_activecalendars.isactive;
	WHERE Type=schedule_activecalendars.typecalendar
	if( TypeCalendar > 2 and (select count(1) from ScheduleCalendarType where Type=schedule_activecalendars.typecalendar) = 0 )
	begin;
	insert into ScheduleCalendarType(Type, Name, IsActive) values(TypeCalendar,'Depart',IsActive)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
