-- ─── PROCEDURE→FUNCTION: workingtime_setworkingtimeweb ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimeweb(integer, integer, integer, integer, character varying, integer, double precision, double precision, character varying, character varying, double precision, double precision, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimeweb(
    IN reguserno integer,
    IN userno integer,
    IN workingday integer,
    IN timetype integer,
    IN checktime character varying,
    IN provider integer,
    IN latitude double precision,
    IN longitude double precision,
    IN remark character varying,
    IN ipserver character varying,
    IN longtime double precision,
    IN timeoffset double precision DEFAULT 0,
    IN locationno integer DEFAULT 0
) RETURNS SETOF record
AS $function$
DECLARE
    workingno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkingTime_Times(RegUserNo, RegDate, UserNo, WorkingDay, TimeType,
		CheckTime, Provider, Latitude, Longitude, Remark,IpServer,TimeCheckLong,TimeOffset,LocationNo)
	VALUES(RegUserNo, NOW(), UserNo, WorkingDay, TimeType,
		CheckTime, Provider, Latitude, Longitude, Remark,IpServer,LongTime,TimeOffset,LocationNo)

	WorkingNo := (lastval());
	---Set Group and user
	EXEC public."WorkingTime_UpdateGroupByUser" p_uid =  workingtime_setworkingtimeweb.userno,  p_wid =  WorkingNo
	--Location and location ousid
	EXEC WorkingTime_UpdateWorKingTimeLocation p_locationno =  workingtime_setworkingtimeweb.locationno, p_type = workingtime_setworkingtimeweb.timetype, p_wid =  WorkingNo

	EXEC public."WorkingTime_Times_v2_Insert" WorkingNo =  WorkingNo, WorkingDay = workingtime_setworkingtimeweb.workingday, CheckTime =  workingtime_setworkingtimeweb.checktime, TimeOffset = workingtime_setworkingtimeweb.timeoffset
	IF Provider = 999 THEN
		EXEC public."WorkingTime_Insert_RequestCorrectionTime" WorkingNo =  WorkingNo, RegUserNo = workingtime_setworkingtimeweb.reguserno, TimeOffset = workingtime_setworkingtimeweb.timeoffset
	END IF;
	RETURN QUERY
	select WorkingNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
