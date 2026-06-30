-- ─── FUNCTION: crewchat_insertiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_insertiosdevice(integer, character varying, boolean, boolean, character varying, character varying, boolean, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertiosdevice(
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
BEGIN


	
	-- 오전 오후 값이 추가되는 현상으로 인한 구문 추가.
	SET NotifyStartTime = (SELECT RIGHT('0000' || CAST(REPLACE(REPLACE(NotifyStartTime,'오전 ',''),'오후 ','') AS NVARCHAR), 5))
	SET NotifyEndTime = (SELECT RIGHT('0000' || CAST(REPLACE(REPLACE(NotifyEndTime,'오전 ',''),'오후 ','') AS NVARCHAR), 5))

	SELECT CNT_iOS = COUNT(*) FROM CrewChat_IOSDevices
	WHERE UserNo=crewchat_insertiosdevice.userno
	
	SELECT CNT_Android = COUNT(*) FROM CrewChat_AndroidDevices
	WHERE UserNo=crewchat_insertiosdevice.userno
	
	IF CNT_iOS = 0
	BEGIN;
		INSERT INTO CrewChat_IOSDevices(UserNo, DeviceID, NotifyEnable, NotifyUseTime,
		 NotifyStartTime, NotifyEndTime, NotifyConfirmOnline, TimeZoneOffset,RegDate)
		VALUES (UserNo, DeviceID, NotifyEnable, NotifyUseTime, NotifyStartTime,
		NotifyEndTime, NotifyConfirmOnline, TimeZoneOffset,NOW())
	END
	ELSE IF CNT_iOS = 1
	BEGIN
		-- 기존 등록된 기기가 있다면, UPDATE ;
		UPDATE CrewChat_IOSDevices SET DeviceID=crewchat_insertiosdevice.deviceid, RegDate = NOW(),
		NotifyEnable = crewchat_insertiosdevice.notifyenable,
		NotifyUseTime = crewchat_insertiosdevice.notifyusetime,
		NotifyStartTime = crewchat_insertiosdevice.notifystarttime,
		NotifyEndTime = crewchat_insertiosdevice.notifyendtime,
		NotifyConfirmOnline = crewchat_insertiosdevice.notifyconfirmonline,
		TimeZoneOffset = crewchat_insertiosdevice.timezoneoffset
		WHERE UserNo = crewchat_insertiosdevice.userno
	END
	ELSE IF CNT_iOS > 1
	BEGIN
		-- 기존 등록된 기기가 2대 이상이라면, 모두 삭제후 현재 요청값 INSERT INTO DELETE FROM CrewChat_IOSDevices WHERE UserNo = UserNo
		
		INSERT INTO CrewChat_IOSDevices(UserNo, DeviceID, NotifyEnable, NotifyUseTime,
		 NotifyStartTime, NotifyEndTime, NotifyConfirmOnline, TimeZoneOffset,RegDate)
		VALUES (UserNo, DeviceID, NotifyEnable, NotifyUseTime, NotifyStartTime,
		NotifyEndTime, NotifyConfirmOnline, TimeZoneOffset,NOW())
	END
	
	-- 안드로이드 디바이스가 등록되어져 있다면, 지운다
	IF CNT_Android > 0
	BEGIN;
		DELETE FROM CrewChat_AndroidDevices WHERE UserNo = crewchat_insertiosdevice.userno
	END
END


/*  2024-11-19 */
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
