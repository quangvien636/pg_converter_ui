-- ─── FUNCTION: workingtime_getofficecountbyworktime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getofficecountbyworktime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getofficecountbyworktime(
    worktimeno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


-- DECLARE LanguageSign nvarchar(5)
 --  SET LanguageSign = 'EN'
	RETURN QUERY
	SELECT COUNT(*)
	 from WorkingTime_Locations_Office WO
	INNER JOIN Organization_Users O
	ON WO.UserNo=O.UserNo
	WHERE WO.WorkTimeNo =workingtime_getofficecountbyworktime.worktimeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
