-- ─── PROCEDURE→FUNCTION: workingtime_getofficecountbylocationno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getofficecountbylocationno(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getofficecountbylocationno(
    IN locationno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
