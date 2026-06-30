-- ─── FUNCTION: workingtime_setworkingtimeservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimeservice(integer, integer, integer, integer, character varying, integer, double precision, double precision, character varying, double precision, character varying, double precision, double precision, double precision, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimeservice(
    reguserno integer,
    userno integer,
    workingday integer,
    timetype integer,
    checktime character varying,
    provider integer,
    latitude double precision,
    longitude double precision,
    remark character varying,
    longtime double precision,
    distance character varying,
    latcompany double precision,
    lngcompany double precision,
    timeoffset double precision DEFAULT 0,
    beaconinfo character varying DEFAULT NULL,
    namecompany character varying DEFAULT NULL,
    locationno integer DEFAULT 0
) RETURNS TABLE(
    workingno text
)
AS $function$
DECLARE
    workingno integer;
BEGIN


	INSERT INTO WorkingTime_Times (RegUserNo, RegDate, UserNo, WorkingDay, TimeType, CheckTime, Provider, Latitude, Longitude, Remark,
		TimeCheckLong, TimeOffset, Distance, LatCompany, LngCompany, BeaconInfo, NameCompany, LocationNo, address)
	VALUES (RegUserNo, NOW(), UserNo, WorkingDay, TimeType, CheckTime, Provider, Latitude, Longitude, Remark,
		LongTime, TimeOffset, Distance, LatCompany, LngCompany, BeaconInfo, NameCompany,LocationNo, p_address)
	SET WorkingNo = lastval()

	EXEC public."WorkingTime_UpdateGroupByUser" p_uid =  workingtime_setworkingtimeservice.userno,  p_wid =  WorkingNo

	EXEC public."WorkingTime_Times_v2_Insert"
		WorkingNo = WorkingNo,
		WorkingDay = workingtime_setworkingtimeservice.workingday,
		CheckTime = workingtime_setworkingtimeservice.checktime,
		TimeOffset = workingtime_setworkingtimeservice.timeoffset
	RETURN QUERY
	SELECT WorkingNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
