-- ─── PROCEDURE→FUNCTION: schedule_insertresourcereservation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_insertresourcereservation(integer, timestamp without time zone, character varying, integer, character varying, integer, integer, integer, integer, integer, integer, date, date, time without time zone, time without time zone, boolean, boolean, boolean, boolean, integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_insertresourcereservation(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN title character varying,
    IN resourceno integer,
    IN content character varying,
    IN repeattype integer,
    IN repeatcount integer,
    IN repeatmonth integer,
    IN repeatweek integer,
    IN repeatday integer,
    IN repeatdows integer,
    IN startdate date,
    IN enddate date,
    IN starttime time without time zone,
    IN endtime time without time zone,
    IN isnotinote boolean,
    IN isnotimail boolean,
    IN isnotisms boolean,
    IN isnotipopup boolean,
    IN notitimetype integer,
    IN p_isallday boolean
) RETURNS SETOF record
AS $function$
DECLARE
    reservationno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	IsRsvn := 0;
	SELECT IsReservation INTO isrsvn FROM ScheduleResources WHERE ResourceNo = schedule_insertresourcereservation.resourceno;

	IF IsRsvn = TRUE THEN
		Status := 'RA';
	ELSE
		Status := 'RW';;
	INSERT INTO ScheduleResourceReservations (
		RegUserNo, RegDate, ModUserNo, ModDate, Title, ResourceNo, Content,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		StartDate, EndDate, StartTime, EndTime,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, RsvnStatus, IsAllDay)
	VALUES (RegUserNo, RegDate, RegUserNo, RegDate, Title, ResourceNo, Content,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		StartDate, EndDate, StartTime, EndTime,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, Status, p_Isallday)
		

	ReservationNo := lastval();
	RETURN QUERY
	SELECT ReservationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
