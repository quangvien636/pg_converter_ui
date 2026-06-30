-- ─── PROCEDURE→FUNCTION: workingtime_setworkingtimeservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_setworkingtimeservice(integer, integer, integer, integer, character varying, integer, double precision, double precision, character varying, double precision, character varying, double precision, double precision, double precision, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtimeservice(
    IN reguserno integer,
    IN userno integer,
    IN workingday integer,
    IN timetype integer,
    IN checktime character varying,
    IN provider integer,
    IN latitude double precision,
    IN longitude double precision,
    IN remark character varying,
    IN longtime double precision,
    IN distance character varying,
    IN latcompany double precision,
    IN lngcompany double precision,
    IN timeoffset double precision DEFAULT 0,
    IN beaconinfo character varying DEFAULT NULL,
    IN namecompany character varying DEFAULT NULL,
    IN locationno integer DEFAULT 0
) RETURNS SETOF record
AS $function$
DECLARE
    workingno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkingTime_Times (RegUserNo, RegDate, UserNo, WorkingDay, TimeType, CheckTime, Provider, Latitude, Longitude, Remark,
		TimeCheckLong, TimeOffset, Distance, LatCompany, LngCompany, BeaconInfo, NameCompany, LocationNo, address)
	VALUES (RegUserNo, NOW(), UserNo, WorkingDay, TimeType, CheckTime, Provider, Latitude, Longitude, Remark,
		LongTime, TimeOffset, Distance, LatCompany, LngCompany, BeaconInfo, NameCompany,LocationNo, p_address)
	WorkingNo := lastval();
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
