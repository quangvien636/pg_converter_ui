-- ─── FUNCTION: workingtime_getofficepagebyworktime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getofficepagebyworktime(integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getofficepagebyworktime(
    worktimeno integer,
    languagesign character varying,
    pagenumber integer,
    pagesize integer
) RETURNS TABLE(
    indexid text,
    id text,
    userno text,
    worktimeno text,
    userid text,
    username text,
    departmentname text,
    positionname text
)
AS $function$
DECLARE
    pagelowerbound integer;
    pageupperbound integer;
BEGIN



SET PageLowerBound = (PageSize * PageNumber) - PageSize
SET PageUpperBound = PageLowerBound + PageSize + 1
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
	 from WorkingTime_Locations_Office WO
	INNER JOIN Organization_Users O
	ON WO.UserNo=O.UserNo
	WHERE WO.WorkTimeNo =workingtime_getofficepagebyworktime.worktimeno ) AS t
WHERE
    t.IndexID > PageLowerBound 
		AND t.IndexID < PageUpperBound;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
