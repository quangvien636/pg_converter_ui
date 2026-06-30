-- ─── FUNCTION: crewchat_updateoptioniosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_updateoptioniosdevice(integer, character varying, boolean, boolean, character varying, character varying, boolean, integer);
CREATE OR REPLACE FUNCTION public.crewchat_updateoptioniosdevice(
    userno integer,
    deviceid character varying,
    notifyenable boolean,
    notifyusetime boolean,
    notifystarttime character varying,
    notifyendtime character varying,
    notifyconfirmonline boolean,
    timezoneoffset integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    cnt_ios bigint;
BEGIN


	SELECT CNT_iOS = COUNT(*) FROM CrewChat_IOSDevices
	WHERE UserNo=crewchat_updateoptioniosdevice.userno
	
	IF CNT_iOS = 1
	BEGIN
		-- 기존 등록된 기기가 있다면, UPDATE ;
		UPDATE CrewChat_IOSDevices SET
		NotifyEnable = crewchat_updateoptioniosdevice.notifyenable,
		NotifyUseTime = crewchat_updateoptioniosdevice.notifyusetime,
		NotifyStartTime = crewchat_updateoptioniosdevice.notifystarttime,
		NotifyEndTime = crewchat_updateoptioniosdevice.notifyendtime,
		NotifyConfirmOnline = crewchat_updateoptioniosdevice.notifyconfirmonline,
		TimeZoneOffset = crewchat_updateoptioniosdevice.timezoneoffset
		WHERE UserNo = crewchat_updateoptioniosdevice.userno AND DeviceID = crewchat_updateoptioniosdevice.deviceid
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
