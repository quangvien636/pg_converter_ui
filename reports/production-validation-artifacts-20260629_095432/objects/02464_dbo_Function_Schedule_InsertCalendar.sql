-- ─── FUNCTION: schedule_insertcalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertcalendar(integer, timestamp without time zone, character varying, integer, character varying, integer, character varying, boolean, boolean, boolean, boolean, integer, boolean, boolean, text);
CREATE OR REPLACE FUNCTION public.schedule_insertcalendar(
    reguserno integer,
    regdate timestamp without time zone,
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
) RETURNS TABLE(
    calendarno text
)
AS $function$
DECLARE
    calendarno integer;
BEGIN


	INSERT INTO ScheduleCalendars (
		RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed,SortOrder,IsActive, isall,isDetail, Detail)
	VALUES (RegUserNo, RegDate, RegUserNo, RegDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, 0, 1, 1, p_isall,p_isDetail, p_Detail)
		

	SET CalendarNo = lastval()
	
	RETURN QUERY
	SELECT CalendarNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
