-- ─── PROCEDURE→FUNCTION: workingtime_getofficepagebylocationno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getofficepagebylocationno(integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getofficepagebylocationno(
    IN locationno integer,
    IN languagesign character varying,
    IN pagenumber integer,
    IN pagesize integer
) RETURNS SETOF record
AS $function$
DECLARE
    pagelowerbound integer;
    pageupperbound integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



PageLowerBound := (PageSize * PageNumber) - PageSize;
PageUpperBound := PageLowerBound + PageSize + 1;
-- DECLARE LanguageSign nvarchar(5)
--   SET LanguageSign = 'EN'
	RETURN QUERY
	SELECT * FROM 
    (SELECT
            ROW_NUMBER() OVER(ORDER BY 
    			WO.Id ASC 
                
            ) AS IndexID, WO.Id,WO.UserNo,WO.WorkTimeNo,O.UserID,
	( case when LanguageSign = 'EN' 
			then O.Name_EN 
			else O.Name end) as UserName,
	( case when LanguageSign = 'EN' 
			then public."UF_DepartmentName_EN"(WO.UserNo) 
			else public."UF_DepartmentName"(WO.UserNo) end) as DepartmentName,
	( case when LanguageSign = 'EN' 
			then public."UF_PositionName_EN"(WO.UserNo) 
			else public."UF_PositionName"(WO.UserNo) end) as PositionName
	 from WorkingTime_Locations_Office WO INNER JOIN WorkingTime_WorkTime WT ON WO.WorkTimeNo = WT.WorkTimeNo
				INNER JOIN Organization_Users O ON WO.UserNo=O.UserNo
	WHERE WT.LocationNo =workingtime_getofficepagebylocationno.locationno ) AS t
WHERE
    t.IndexID > PageLowerBound 
		AND t.IndexID < PageUpperBound;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
