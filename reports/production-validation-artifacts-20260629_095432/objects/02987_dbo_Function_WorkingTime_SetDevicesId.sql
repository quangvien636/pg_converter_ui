-- ─── FUNCTION: workingtime_setdevicesid ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_setdevicesid(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setdevicesid(
    departno integer,
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    _allowdeviceno integer;
    _countdeviceno integer;
BEGIN




	SELECT _AllowDeviceNo = COUNT(AllowDeviceNo) FROM WorkingTime_AllowDevices WHERE UserNo = workingtime_setdevicesid.userno
	SELECT _CountDeviceNo = COUNT(AllowDeviceNo) FROM WorkingTime_AllowDevices 
	WHERE DeviceId = DeviceId 
	AND UserNo != workingtime_setdevicesid.userno
	AND DeviceId NOT ILIKE '%0000-0000%' -- CASE CAN NOT GET DIVICEID

	IF (_CountDeviceNo <= 0) BEGIN
		IF (_AllowDeviceNo > 0) BEGIN;
			UPDATE WorkingTime_AllowDevices
					SET DepartNo = workingtime_setdevicesid.departno,
						UserNo = workingtime_setdevicesid.userno,
						DeviceId =DeviceId
					WHERE UserNo = workingtime_setdevicesid.userno AND (DeviceId ='' OR DeviceId Is null)
		END
		ELSE BEGIN;
			INSERT INTO WorkingTime_AllowDevices (DepartNo, UserNo, ContentAllow, ModDate, RegDate,IsUserFull,DeviceId)
			VALUES (DepartNo, UserNo, '[{"Device":"PC","Allow":true},{"Device":"MOBILE","Allow":true}]', NOW(), NOW(),0,DeviceId)
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
