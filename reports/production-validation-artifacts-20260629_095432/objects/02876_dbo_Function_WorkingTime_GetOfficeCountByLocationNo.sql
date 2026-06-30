-- ─── FUNCTION: workingtime_getofficecountbylocationno ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getofficecountbylocationno(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getofficecountbylocationno(
    locationno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


-- DECLARE LanguageSign nvarchar(5)
--   SET LanguageSign = 'EN'
	RETURN QUERY
	SELECT COUNT(*)
	 from WorkingTime_Locations_Office WO INNER JOIN WorkingTime_WorkTime WT ON WO.WorkTimeNo = WT.WorkTimeNo
				INNER JOIN Organization_Users O ON WO.UserNo=O.UserNo
	WHERE WT.LocationNo =workingtime_getofficecountbylocationno.locationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
