-- ─── PROCEDURE→FUNCTION: workingtime_getofficebyworktime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getofficebyworktime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getofficebyworktime(
    IN worktimeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


-- DECLARE LanguageSign nvarchar(5)
 --  SET LanguageSign = 'EN'
	RETURN QUERY
	SELECT WO.Id,WO.UserNo,WO.WorkTimeNo,O.UserID,
	( case when LanguageSign = 'EN' 
			then O.Name_EN 
			else O.Name end) as UserName,
	( case when LanguageSign = 'EN' 
			then public."UF_DepartmentName_EN"(WO.UserNo) 
			else public."UF_DepartmentName"(WO.UserNo) end) as DepartmentName,
	( case when LanguageSign = 'EN' 
			then public."UF_PositionName_EN"(WO.UserNo) 
			else public."UF_PositionName"(WO.UserNo) end) as PositionName
	 from WorkingTime_Locations_Office WO
	INNER JOIN Organization_Users O
	ON WO.UserNo=O.UserNo
	WHERE WO.WorkTimeNo =workingtime_getofficebyworktime.worktimeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
