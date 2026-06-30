-- ─── FUNCTION: schedule_activecalendars ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_activecalendars(integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_activecalendars(
    typecalendar integer,
    isactive boolean
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleCalendars 
	SET IsActive=schedule_activecalendars.isactive
	WHERE Type=schedule_activecalendars.typecalendar

	UPDATE ScheduleCalendarType
	SET IsActive=schedule_activecalendars.isactive
	WHERE Type=schedule_activecalendars.typecalendar
	if( TypeCalendar > 2 and (select count(1) from ScheduleCalendarType where Type=schedule_activecalendars.typecalendar) = 0 )
	begin;
	insert into ScheduleCalendarType(Type, Name, IsActive) values(TypeCalendar,'Depart',IsActive)
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
