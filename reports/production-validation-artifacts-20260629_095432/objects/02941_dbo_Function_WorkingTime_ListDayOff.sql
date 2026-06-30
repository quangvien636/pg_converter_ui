-- ─── FUNCTION: workingtime_listdayoff ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_listdayoff(timestamp without time zone, timestamp without time zone, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_listdayoff(
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_departno integer DEFAULT 0,
    p_groupno integer DEFAULT 0,
    p_uid character varying DEFAULT '',
    p_uname character varying DEFAULT '',
    p_unameen character varying DEFAULT ''
) RETURNS TABLE(
    workingdayofcompany text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT 

		B.UserNo, U.UserID, U.Name, U.Name_EN,
		D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN,
		P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN,
		COALESCE(S.SortNo, P.SortNo) SortNo
		into #ListOfUsers
	FROM Organization_BelongToDepartment B 
	INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
	INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	JOIN (SELECT u1.UserNo FROM Organization_Users U1 LEFT JOIN WorkingTime_AllowDevices A ON U1.userno = a.userno	where COALESCE(ContentAllow, 'true') ILIKE '%true%') AL ON U.UserNo = AL.UserNo
	LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = U.UserNo and S.DepartNo = workingtime_listdayoff.p_departno
	WHERE (p_DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_DepartNo, 0)))
	AND B.IsDefault = TRUE
	AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_listdayoff.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_listdayoff.p_groupno))
	AND (p_Uid = '' OR LOWER(U.UserID) ILIKE '%' || p_Uid || '%')
	AND (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%')
	AND (p_UNameEn = '' OR LOWER(U.Name_EN) ILIKE '%' || p_UNameEn || '%')
	IF (p_To > NOW()) SET p_To = NOW();
	WITH nums AS(SELECT 0 AS number UNION ALL  SELECT number + 1 AS number FROM nums  WHERE nums.number <=31)   
	RETURN QUERY
	SELECT
		L.UserNo,
		L.Name AS UserName,
		L.Name_EN AS UserNameEN,
		L.PositionName AS Position,
		L.PositionName_EN AS PositionEN,
		L.DepartName AS Department,
		L.DepartName_EN AS DepartmentEN,
		DATEADD(DAY,number,p_From) AS DateCheck1,
		L.SortNo
	FROM nums 
	INNER JOIN #ListOfUsers L ON 1 = 1
	WHERE  DATEADD(DAY, number, p_From) <= workingtime_listdayoff.p_to 
		AND DATEADD(DAY, number, p_From) <= NOW() 
		AND CAST(CONVERT(VARCHAR(8), DATEADD(DAY,number, p_From), 112) AS INT) NOT IN (
				SELECT 
					wt2.WorkingDayOfCompany
				FROM WorkingTime_Times wt  
				INNER JOIN WorkingTime_Times_v2 wt2  ON wt.WorkingNo = wt2.WorkingNo
				LEFT JOIN WorkingTime_RequestCorrectionTime wr  ON wt.WorkingNo = wr.WorkingNo
				WHERE wt2.WorkingDayOfCompany BETWEEN CAST(CONVERT(VARCHAR(8), p_From, 112) AS INT) 
					AND CAST(CONVERT(VARCHAR(8), p_To, 112) AS INT) 
					AND COALESCE(wr.Status, 1) = 1
					AND wt.UserNo = L.UserNo
		)
	ORDER BY DateCheck1, SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
