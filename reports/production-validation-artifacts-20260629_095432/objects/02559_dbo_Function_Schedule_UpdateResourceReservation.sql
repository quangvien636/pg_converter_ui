-- ─── FUNCTION: schedule_updateresourcereservation ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateresourcereservation(integer, integer, timestamp without time zone, character varying, integer, character varying, integer, integer, integer, integer, integer, integer, date, date, time without time zone, time without time zone, boolean, boolean, boolean, boolean, integer, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateresourcereservation(
    reservationno integer,
    moduserno integer,
    moddate timestamp without time zone,
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
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleResourceReservations SET
		ModUserNo = schedule_updateresourcereservation.moduserno,
		ModDate = schedule_updateresourcereservation.moddate,
		Title = schedule_updateresourcereservation.title,
		ResourceNo = schedule_updateresourcereservation.resourceno,
		Content = schedule_updateresourcereservation.content,
		RepeatType = schedule_updateresourcereservation.repeattype,
		RepeatCount = schedule_updateresourcereservation.repeatcount,
		RepeatMonth = schedule_updateresourcereservation.repeatmonth,
		RepeatWeek = schedule_updateresourcereservation.repeatweek,
		RepeatDay = schedule_updateresourcereservation.repeatday,
		RepeatDOWs = schedule_updateresourcereservation.repeatdows,
		StartDate = schedule_updateresourcereservation.startdate,
		EndDate = schedule_updateresourcereservation.enddate,
		StartTime = schedule_updateresourcereservation.starttime,
		EndTime = schedule_updateresourcereservation.endtime,
		IsNotiNote = schedule_updateresourcereservation.isnotinote,
		IsNotiMail = schedule_updateresourcereservation.isnotimail,
		IsNotiSMS = schedule_updateresourcereservation.isnotisms,
		IsNotiPopup = schedule_updateresourcereservation.isnotipopup,
		NotiTimeType = schedule_updateresourcereservation.notitimetype,
		IsAllDay = schedule_updateresourcereservation.p_isallday
	WHERE ReservationNo = schedule_updateresourcereservation.reservationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
