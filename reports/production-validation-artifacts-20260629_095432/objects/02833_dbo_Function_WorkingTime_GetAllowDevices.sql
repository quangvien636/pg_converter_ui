-- ─── FUNCTION: workingtime_getallowdevices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getallowdevices();
CREATE OR REPLACE FUNCTION public.workingtime_getallowdevices(
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    tableuser_allow table(
	userno int
	);
BEGIN


	INSERT INTO TABLEUSER_ALLOW
	EXEC WorkingTime_GetUserNoAllowDevice

	RETURN QUERY
	SELECT w.* FROM WorkingTime_AllowDevices w inner join TABLEUSER_ALLOW t on w.UserNo = t.UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
