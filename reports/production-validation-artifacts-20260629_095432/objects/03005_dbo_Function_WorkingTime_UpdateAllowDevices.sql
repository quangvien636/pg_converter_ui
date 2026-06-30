-- ─── FUNCTION: workingtime_updateallowdevices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateallowdevices(integer, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.workingtime_updateallowdevices(
    departno integer,
    userno integer,
    contentallow character varying,
    isuserfull boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    _allowdeviceno integer;
BEGIN



	SELECT _AllowDeviceNo = COUNT(AllowDeviceNo) FROM WorkingTime_AllowDevices WHERE UserNo = workingtime_updateallowdevices.userno

	IF (_AllowDeviceNo > 0) BEGIN;
		UPDATE WorkingTime_AllowDevices
			SET DepartNo = workingtime_updateallowdevices.departno,
				UserNo = workingtime_updateallowdevices.userno,
				ContentAllow = workingtime_updateallowdevices.contentallow,
				IsUserFull = workingtime_updateallowdevices.isuserfull
			WHERE UserNo = workingtime_updateallowdevices.userno
	END
	ELSE BEGIN;
		INSERT INTO WorkingTime_AllowDevices(DepartNo,UserNo,ContentAllow,IsUserFull) VALUES (DepartNo,UserNo,ContentAllow,IsUserFull)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
