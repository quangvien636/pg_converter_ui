-- ─── FUNCTION: schedule_getresevationbyno ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresevationbyno(integer);
CREATE OR REPLACE FUNCTION public.schedule_getresevationbyno(
    p_rno integer
) RETURNS TABLE(
    reservationno serial,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    title character varying(100),
    resourceno integer,
    content character varying(500),
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
    rsvnstatus character(2),
    processdate timestamp without time zone,
    processuserno integer,
    reason character varying(500),
    processview boolean,
    userview boolean,
    isallday boolean
)
AS $function$
BEGIN

	RETURN QUERY
	select *  FROM ScheduleResourceReservations 
	WHERE ResourceNo = schedule_getresevationbyno.p_rno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
