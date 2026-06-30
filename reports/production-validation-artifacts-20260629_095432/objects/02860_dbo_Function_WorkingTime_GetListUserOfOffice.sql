-- ─── FUNCTION: workingtime_getlistuserofoffice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlistuserofoffice(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlistuserofoffice(
    userno integer
) RETURNS TABLE(
    id text,
    userno text,
    locationno text,
    daycreate text,
    isworking text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT id, UserNo, LocationNo, DayCreate, IsWorking
	FROM WorkingTime_Locations_Office
	WHERE UserNo = workingtime_getlistuserofoffice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
