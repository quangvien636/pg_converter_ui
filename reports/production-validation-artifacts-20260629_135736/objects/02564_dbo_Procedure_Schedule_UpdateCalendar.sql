-- ─── PROCEDURE→FUNCTION: schedule_updatecalendar ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatecalendar(integer, integer, timestamp without time zone, character varying, integer, character varying, integer, character varying, boolean, boolean, boolean, boolean, integer, boolean, boolean, text);
CREATE OR REPLACE FUNCTION public.schedule_updatecalendar(
    IN calendarno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN type integer,
    IN color character varying,
    IN uselevel integer,
    IN description character varying,
    IN isnotinote boolean,
    IN isnotimail boolean,
    IN isnotisms boolean,
    IN isnotipopup boolean,
    IN notitimetype integer,
    IN p_isall boolean DEFAULT FALSE,
    IN p_isdetail boolean DEFAULT FALSE,
    IN p_detail text DEFAULT ''
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleCalendars
	ModUserNo := schedule_updatecalendar.moduserno, ModDate = schedule_updatecalendar.moddate, Name = schedule_updatecalendar.name, Type = schedule_updatecalendar.type,;
		Color = schedule_updatecalendar.color, UseLevel = schedule_updatecalendar.uselevel, Description = schedule_updatecalendar.description,
		IsNotiNote = schedule_updatecalendar.isnotinote, IsNotiMail = schedule_updatecalendar.isnotimail, IsNotiSMS = schedule_updatecalendar.isnotisms, IsNotiPopup = schedule_updatecalendar.isnotipopup,
		NotiTimeType = schedule_updatecalendar.notitimetype,
		isall = schedule_updatecalendar.p_isall
		, isDetail = schedule_updatecalendar.p_isdetail
		, Detail = schedule_updatecalendar.p_detail
	WHERE CalendarNo = schedule_updatecalendar.calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
