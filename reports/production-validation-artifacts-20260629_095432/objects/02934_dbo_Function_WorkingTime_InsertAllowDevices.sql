-- ─── FUNCTION: workingtime_insertallowdevices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_insertallowdevices(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_insertallowdevices(
    departno integer,
    userno integer
) RETURNS TABLE(
    allowdeviceno text
)
AS $function$
DECLARE
    allowdeviceno integer;
BEGIN

	INSERT INTO WorkingTime_AllowDevices(DepartNo,UserNo,ContentAllow) VALUES (DepartNo,UserNo,ContentAllow)


	SET AllowDeviceNo = lastval()

	RETURN QUERY
	SELECT AllowDeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
