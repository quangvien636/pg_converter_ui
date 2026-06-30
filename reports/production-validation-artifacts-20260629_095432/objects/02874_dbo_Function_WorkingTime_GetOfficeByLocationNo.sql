-- ─── FUNCTION: workingtime_getofficebylocationno ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getofficebylocationno(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getofficebylocationno(
    locationno integer
) RETURNS TABLE(
    id text,
    userno text,
    worktimeno text,
    userid text,
    username text,
    departmentname text,
    positionname text
)
AS $function$
BEGIN


-- DECLARE LanguageSign nvarchar(5)
--   SET LanguageSign = 'EN'
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
	 from WorkingTime_Locations_Office WO INNER JOIN WorkingTime_WorkTime WT ON WO.WorkTimeNo = WT.WorkTimeNo
				INNER JOIN Organization_Users O ON WO.UserNo=O.UserNo
	WHERE WT.LocationNo =workingtime_getofficebylocationno.locationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
