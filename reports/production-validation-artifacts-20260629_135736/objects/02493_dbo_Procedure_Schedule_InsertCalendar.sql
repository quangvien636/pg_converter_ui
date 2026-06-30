-- ─── PROCEDURE→FUNCTION: schedule_insertcalendar ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_insertcalendar(integer, timestamp without time zone, character varying, integer, character varying, integer, character varying, boolean, boolean, boolean, boolean, integer, boolean, boolean, text);
CREATE OR REPLACE FUNCTION public.schedule_insertcalendar(
    IN reguserno integer,
    IN regdate timestamp without time zone,
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
) RETURNS SETOF record
AS $function$
DECLARE
    calendarno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO ScheduleCalendars (
		RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed,SortOrder,IsActive, isall,isDetail, Detail)
	VALUES (RegUserNo, RegDate, RegUserNo, RegDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, 0, 1, 1, p_isall,p_isDetail, p_Detail)
		

	CalendarNo := lastval();
	RETURN QUERY
	SELECT CalendarNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
