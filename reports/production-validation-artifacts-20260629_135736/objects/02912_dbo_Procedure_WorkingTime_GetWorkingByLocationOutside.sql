-- ─── PROCEDURE→FUNCTION: workingtime_getworkingbylocationoutside ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getworkingbylocationoutside(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingbylocationoutside(
    IN locationno integer,
    IN fromdate integer,
    IN todate integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT T.WorkingNo
	   ,T.RegUserNo
	   ,T.LocationNo
	   ,T.WorkingDay
	   ,T.CheckTime
	   ,U.Name UserName
	   ,U.Name_EN UserNameEN
	   ,d.Name as DepartName
	   , d.Name_EN as DepartName_EN
	   ,p.Name as PositionName
	   ,p.Name_EN as PositionName_EN
	FROM WorkingTime_Times  T
	JOIN  Organization_Users U ON T.RegUserNo = U.UserNo
	LEFT join Organization_BelongToDepartment  B  ON t.UserNo = B.UserNo  AND U.IsVirtual = FALSE AND U.Enabled = TRUE and B.IsDefault = TRUE
	LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	WHERE T.TimeType = 2 AND  T.LocationNo = workingtime_getworkingbylocationoutside.locationno AND T.WorkingDay BETWEEN FromDate AND ToDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
