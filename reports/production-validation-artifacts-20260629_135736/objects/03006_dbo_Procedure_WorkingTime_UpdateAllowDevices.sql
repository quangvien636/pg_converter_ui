-- ─── PROCEDURE→FUNCTION: workingtime_updateallowdevices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_updateallowdevices(integer, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.workingtime_updateallowdevices(
    IN departno integer,
    IN userno integer,
    IN contentallow character varying,
    IN isuserfull boolean
) RETURNS SETOF record
AS $function$
DECLARE
    _allowdeviceno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT COUNT(AllowDeviceNo) INTO _allowdeviceno FROM WorkingTime_AllowDevices WHERE UserNo = workingtime_updateallowdevices.userno

	IF _AllowDeviceNo > 0 THEN;
		UPDATE WorkingTime_AllowDevices
			DepartNo := workingtime_updateallowdevices.departno,;
				UserNo = workingtime_updateallowdevices.userno,
				ContentAllow = workingtime_updateallowdevices.contentallow,
				IsUserFull = workingtime_updateallowdevices.isuserfull
			WHERE UserNo = workingtime_updateallowdevices.userno
	END IF;
	ELSE BEGIN;
		INSERT INTO WorkingTime_AllowDevices(DepartNo,UserNo,ContentAllow,IsUserFull) VALUES (DepartNo,UserNo,ContentAllow,IsUserFull)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
