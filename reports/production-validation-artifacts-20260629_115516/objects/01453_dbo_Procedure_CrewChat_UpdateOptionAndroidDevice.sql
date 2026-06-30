-- ─── PROCEDURE→FUNCTION: crewchat_updateoptionandroiddevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_updateoptionandroiddevice(integer, character varying, boolean, boolean, boolean, boolean, character varying, character varying, boolean, integer);
CREATE OR REPLACE FUNCTION public.crewchat_updateoptionandroiddevice(
    IN userno integer,
    IN deviceid character varying,
    IN notifyenable boolean,
    IN notifysound boolean,
    IN notifyvibrate boolean,
    IN notifyusetime boolean,
    IN notifystarttime character varying,
    IN notifyendtime character varying,
    IN notifyconfirmonline boolean,
    IN timezoneoffset integer
) RETURNS SETOF record
AS $function$
DECLARE
    cnt bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT COUNT(*) INTO cnt FROM CrewChat_AndroidDevices
	WHERE UserNo=crewchat_updateoptionandroiddevice.userno
	
	IF CNT = 1 THEN
		-- 기존 등록된 기기가 있다면, UPDATE ;
		UPDATE CrewChat_AndroidDevices SET
		NotifyEnable = crewchat_updateoptionandroiddevice.notifyenable,
		NotifySound = crewchat_updateoptionandroiddevice.notifysound,
		NotifyVibrate = crewchat_updateoptionandroiddevice.notifyvibrate,
		NotifyUseTime = crewchat_updateoptionandroiddevice.notifyusetime,
		NotifyStartTime = crewchat_updateoptionandroiddevice.notifystarttime,
		NotifyEndTime = crewchat_updateoptionandroiddevice.notifyendtime,
		NotifyConfirmOnline = crewchat_updateoptionandroiddevice.notifyconfirmonline,
		TimeZoneOffset = crewchat_updateoptionandroiddevice.timezoneoffset
		WHERE UserNo = crewchat_updateoptionandroiddevice.userno AND DeviceID = crewchat_updateoptionandroiddevice.deviceid
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
