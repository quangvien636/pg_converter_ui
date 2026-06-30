-- ─── FUNCTION: workingtime_getworkingtime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime(
    workingno integer
) RETURNS TABLE(
    workingno serial,
    reguserno integer,
    regdate timestamp without time zone,
    userno integer,
    workingday integer,
    timetype integer,
    checktime character(6),
    provider integer,
    latitude double precision,
    longitude double precision,
    remark character varying(500),
    ipserver character varying(250),
    timechecklong double precision,
    timeoffset double precision,
    distance character varying(250),
    latcompany double precision,
    lngcompany double precision,
    beaconinfo character varying(500),
    namecompany character varying(500),
    postid character varying(50),
    postname character varying(500),
    deptid character varying(50),
    deptname character varying(500),
    locationno integer,
    groupid integer,
    lunchstart character(4),
    lunchend character(4),
    starworking character(4),
    endworking character(4),
    isaddlunch boolean,
    bin1 character(4),
    bout1 character(4),
    bin2 character(4),
    bout2 character(4),
    isb1 boolean,
    isb2 boolean,
    timeworking integer,
    workingdayc integer,
    checktimec integer,
    checktimefull timestamp without time zone,
    timeworking2 integer,
    address character varying(600),
    status integer,
    dateupdate timestamp without time zone,
    datedelete timestamp without time zone,
    checktimefullo timestamp without time zone,
    userdeleted integer,
    bno integer,
    bname character varying(500),
    timeworkingf integer,
    timeworkingf2 integer
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT *
	FROM WorkingTime_Times W 
	WHERE WorkingNo = workingtime_getworkingtime.workingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
