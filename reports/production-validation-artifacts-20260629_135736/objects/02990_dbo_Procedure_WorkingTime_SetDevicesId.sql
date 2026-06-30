-- ─── PROCEDURE→FUNCTION: workingtime_setdevicesid ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_setdevicesid(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_setdevicesid(
    IN departno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    _allowdeviceno integer;
    _countdeviceno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SELECT COUNT(AllowDeviceNo) INTO _allowdeviceno FROM WorkingTime_AllowDevices WHERE UserNo = workingtime_setdevicesid.userno
	SELECT COUNT(AllowDeviceNo) INTO _countdeviceno FROM WorkingTime_AllowDevices 
	WHERE DeviceId = DeviceId 
	AND UserNo != workingtime_setdevicesid.userno
	AND DeviceId NOT ILIKE '%0000-0000%' -- CASE CAN NOT GET DIVICEID

	IF _CountDeviceNo <= 0 THEN
		IF _AllowDeviceNo > 0 THEN;
			UPDATE WorkingTime_AllowDevices
					DepartNo := workingtime_setdevicesid.departno,;
						UserNo = workingtime_setdevicesid.userno,
						DeviceId =DeviceId
					WHERE UserNo = workingtime_setdevicesid.userno AND (DeviceId ='' OR DeviceId Is null)
		END IF;
		ELSE BEGIN;
			INSERT INTO WorkingTime_AllowDevices (DepartNo, UserNo, ContentAllow, ModDate, RegDate,IsUserFull,DeviceId)
			VALUES (DepartNo, UserNo, '[{"Device":"PC","Allow":true},{"Device":"MOBILE","Allow":true}]', NOW(), NOW(),0,DeviceId)
		END IF;
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
