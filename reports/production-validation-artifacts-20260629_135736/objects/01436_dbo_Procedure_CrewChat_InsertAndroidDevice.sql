-- ─── PROCEDURE→FUNCTION: crewchat_insertandroiddevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_insertandroiddevice(integer, character varying, boolean, boolean, boolean, boolean, character varying, character varying, boolean, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertandroiddevice(
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
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	

	SELECT COUNT(*) INTO cnt_ios FROM CrewChat_IOSDevices
	WHERE UserNo=crewchat_insertandroiddevice.userno
	
	SELECT COUNT(*) INTO cnt_android FROM CrewChat_AndroidDevices
	WHERE UserNo=crewchat_insertandroiddevice.userno

	IF CNT_Android = 0 THEN
		-- 사용자가 없다면 신규로 INSERT INTO INSERT INTO CrewChat_AndroidDevices(UserNo, DeviceID, NotifyEnable, NotifySound,
		 NotifyVibrate, NotifyUseTime, NotifyStartTime, NotifyEndTime, 
		 NotifyConfirmOnline, TimeZoneOffset)
		VALUES (UserNo, DeviceID, NotifyEnable, NotifySound, 
		NotifyVibrate, NotifyUseTime, NotifyStartTime, NotifyEndTime, 
		NotifyConfirmOnline, TimeZoneOffset)
	END IF;
	ELSIF CNT_Android = 1 THEN
		-- 기존 등록된 기기가 있다면, UPDATE ;
		UPDATE CrewChat_AndroidDevices SET DeviceID=crewchat_insertandroiddevice.deviceid, RegDate = NOW(),
		NotifyEnable = crewchat_insertandroiddevice.notifyenable,
		NotifySound = crewchat_insertandroiddevice.notifysound,
		NotifyVibrate = crewchat_insertandroiddevice.notifyvibrate,
		NotifyUseTime = crewchat_insertandroiddevice.notifyusetime,
		NotifyStartTime = crewchat_insertandroiddevice.notifystarttime,
		NotifyEndTime = crewchat_insertandroiddevice.notifyendtime,
		NotifyConfirmOnline = crewchat_insertandroiddevice.notifyconfirmonline,
		TimeZoneOffset = crewchat_insertandroiddevice.timezoneoffset
		WHERE UserNo = crewchat_insertandroiddevice.userno
	END IF;
	ELSIF CNT_Android > 1 THEN
		-- 기존 등록된 기기가 2대 이상이라면, 모두 삭제후 현재 요청값 INSERT INTO DELETE FROM CrewChat_AndroidDevices WHERE UserNo = UserNo
		
		INSERT INTO CrewChat_AndroidDevices(UserNo, DeviceID, NotifyEnable, NotifySound,
		 NotifyVibrate, NotifyUseTime, NotifyStartTime, NotifyEndTime, 
		 NotifyConfirmOnline, TimeZoneOffset)
		VALUES (UserNo, DeviceID, NotifyEnable, NotifySound, 
		NotifyVibrate, NotifyUseTime, NotifyStartTime, NotifyEndTime, 
		NotifyConfirmOnline, TimeZoneOffset)
	END IF;
	
	-- iOS 디바이스 등록되어 있다면 지운다
	--IF CNT_iOS > 0
	--BEGIN
	--	DELETE FROM CrewChat_IOSDevices WHERE UserNo = UserNo
	--END
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
