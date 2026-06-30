-- ─── FUNCTION: schedule_updatecalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatecalendar(integer, integer, timestamp without time zone, character varying, integer, character varying, integer, character varying, boolean, boolean, boolean, boolean, integer, boolean, boolean, text);
CREATE OR REPLACE FUNCTION public.schedule_updatecalendar(
    calendarno integer,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    type integer,
    color character varying,
    uselevel integer,
    description character varying,
    isnotinote boolean,
    isnotimail boolean,
    isnotisms boolean,
    isnotipopup boolean,
    notitimetype integer,
    p_isall boolean DEFAULT FALSE,
    p_isdetail boolean DEFAULT FALSE,
    p_detail text DEFAULT ''
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleCalendars
	SET ModUserNo = schedule_updatecalendar.moduserno, ModDate = schedule_updatecalendar.moddate, Name = schedule_updatecalendar.name, Type = schedule_updatecalendar.type,
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
