-- ─── FUNCTION: crewchat_updateoptionandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_updateoptionandroiddevice(integer, character varying, boolean, boolean, boolean, boolean, character varying, character varying, boolean, integer);
CREATE OR REPLACE FUNCTION public.crewchat_updateoptionandroiddevice(
    userno integer,
    deviceid character varying,
    notifyenable boolean,
    notifysound boolean,
    notifyvibrate boolean,
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
    cnt bigint;
BEGIN


	SELECT CNT = COUNT(*) FROM CrewChat_AndroidDevices
	WHERE UserNo=crewchat_updateoptionandroiddevice.userno
	
	IF CNT = 1
	BEGIN
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
