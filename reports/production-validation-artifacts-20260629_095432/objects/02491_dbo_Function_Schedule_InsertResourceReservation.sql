-- ─── FUNCTION: schedule_insertresourcereservation ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertresourcereservation(integer, timestamp without time zone, character varying, integer, character varying, integer, integer, integer, integer, integer, integer, date, date, time without time zone, time without time zone, boolean, boolean, boolean, boolean, integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_insertresourcereservation(
    reguserno integer,
    regdate timestamp without time zone,
    title character varying,
    resourceno integer,
    content character varying,
    repeattype integer,
    repeatcount integer,
    repeatmonth integer,
    repeatweek integer,
    repeatday integer,
    repeatdows integer,
    startdate date,
    enddate date,
    starttime time without time zone,
    endtime time without time zone,
    isnotinote boolean,
    isnotimail boolean,
    isnotisms boolean,
    isnotipopup boolean,
    notitimetype integer,
    p_isallday boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    reservationno integer;
BEGIN




	SET IsRsvn = FALSE;

	SELECT IsRsvn = IsReservation FROM ScheduleResources WHERE ResourceNo = schedule_insertresourcereservation.resourceno;

	IF IsRsvn = TRUE
		SET Status = 'RA';
	ELSE
		SET Status = 'RW';

	INSERT INTO ScheduleResourceReservations (
		RegUserNo, RegDate, ModUserNo, ModDate, Title, ResourceNo, Content,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		StartDate, EndDate, StartTime, EndTime,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, RsvnStatus, IsAllDay)
	VALUES (RegUserNo, RegDate, RegUserNo, RegDate, Title, ResourceNo, Content,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		StartDate, EndDate, StartTime, EndTime,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, Status, p_Isallday)
		

	SET ReservationNo = lastval()
	
	RETURN QUERY
	SELECT ReservationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
