-- ─── PROCEDURE→FUNCTION: crewchat_updateoptioniosdevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_updateoptioniosdevice(integer, character varying, boolean, boolean, character varying, character varying, boolean, integer);
CREATE OR REPLACE FUNCTION public.crewchat_updateoptioniosdevice(
    IN userno integer,
    IN deviceid character varying,
    IN notifyenable boolean,
    IN notifyusetime boolean,
    IN notifystarttime character varying,
    IN notifyendtime character varying,
    IN notifyconfirmonline boolean,
    IN timezoneoffset integer
) RETURNS SETOF record
AS $function$
DECLARE
    cnt_ios bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT COUNT(*) INTO cnt_ios FROM CrewChat_IOSDevices
	WHERE UserNo=crewchat_updateoptioniosdevice.userno
	
	IF CNT_iOS = 1 THEN
		-- 기존 등록된 기기가 있다면, UPDATE ;
		UPDATE CrewChat_IOSDevices SET
		NotifyEnable = crewchat_updateoptioniosdevice.notifyenable,
		NotifyUseTime = crewchat_updateoptioniosdevice.notifyusetime,
		NotifyStartTime = crewchat_updateoptioniosdevice.notifystarttime,
		NotifyEndTime = crewchat_updateoptioniosdevice.notifyendtime,
		NotifyConfirmOnline = crewchat_updateoptioniosdevice.notifyconfirmonline,
		TimeZoneOffset = crewchat_updateoptioniosdevice.timezoneoffset
		WHERE UserNo = crewchat_updateoptioniosdevice.userno AND DeviceID = crewchat_updateoptioniosdevice.deviceid
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
