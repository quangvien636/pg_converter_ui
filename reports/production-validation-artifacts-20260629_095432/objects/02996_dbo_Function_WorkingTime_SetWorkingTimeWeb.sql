-- ─── FUNCTION: workingtime_setworkingtimeweb ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimeweb(integer, integer, integer, integer, character varying, integer, double precision, double precision, character varying, character varying, double precision, double precision, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimeweb(
    reguserno integer,
    userno integer,
    workingday integer,
    timetype integer,
    checktime character varying,
    provider integer,
    latitude double precision,
    longitude double precision,
    remark character varying,
    ipserver character varying,
    longtime double precision,
    timeoffset double precision DEFAULT 0,
    locationno integer DEFAULT 0
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text,
    col4 text,
    col5 text,
    col6 text,
    col7 text,
    col8 text,
    col9 text
)
AS $function$
DECLARE
    workingno integer;
BEGIN


	INSERT INTO WorkingTime_Times(RegUserNo, RegDate, UserNo, WorkingDay, TimeType,
		CheckTime, Provider, Latitude, Longitude, Remark,IpServer,TimeCheckLong,TimeOffset,LocationNo)
	VALUES(RegUserNo, NOW(), UserNo, WorkingDay, TimeType,
		CheckTime, Provider, Latitude, Longitude, Remark,IpServer,LongTime,TimeOffset,LocationNo)

	SELECT WorkingNo = lastval()
	---Set Group and user
	EXEC public."WorkingTime_UpdateGroupByUser" p_uid =  workingtime_setworkingtimeweb.userno,  p_wid =  WorkingNo
	--Location and location ousid
	EXEC WorkingTime_UpdateWorKingTimeLocation p_locationno =  workingtime_setworkingtimeweb.locationno, p_type = workingtime_setworkingtimeweb.timetype, p_wid =  WorkingNo

	EXEC public."WorkingTime_Times_v2_Insert" WorkingNo =  WorkingNo, WorkingDay = workingtime_setworkingtimeweb.workingday, CheckTime =  workingtime_setworkingtimeweb.checktime, TimeOffset = workingtime_setworkingtimeweb.timeoffset
	IF Provider = 999 BEGIN
		EXEC public."WorkingTime_Insert_RequestCorrectionTime" WorkingNo =  WorkingNo, RegUserNo = workingtime_setworkingtimeweb.reguserno, TimeOffset = workingtime_setworkingtimeweb.timeoffset
	END
	RETURN QUERY
	select WorkingNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
