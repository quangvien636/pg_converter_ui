-- ─── FUNCTION: workingtime_employeeoffvacations ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_employeeoffvacations(integer, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_employeeoffvacations(
    p_from integer,
    p_to integer,
    p_departno integer DEFAULT 0,
    p_groupno integer DEFAULT 0,
    p_uid character varying DEFAULT '',
    p_uname character varying DEFAULT '',
    p_unameen character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	
	SELECT t.UserNo INTO #TAM
						FROM WorkingTime_Times t
						where (t.TimeType between -7 and -1 or t.TimeType < -10) and WorkingDayC BETWEEN p_From AND p_To
	GROUP BY t.UserNo
	SELECT 

		B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN,
		D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN,
		P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN
	FROM Organization_BelongToDepartment B 
	JOIN #TAM T ON T.UserNo = B.UserNo
	INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
	INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
	LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
	LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = U.UserNo and S.DepartNo = workingtime_employeeoffvacations.p_departno
	WHERE (p_DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_DepartNo, 0)))
	AND B.IsDefault = TRUE
	AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_employeeoffvacations.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_employeeoffvacations.p_groupno))
	AND ( (p_GroupNo = 0 OR G.ID = workingtime_employeeoffvacations.p_groupno) OR (p_GroupNo !=  0 AND G.ID = workingtime_employeeoffvacations.p_groupno))
	AND (p_Uid = '' OR LOWER(U.UserID) ILIKE '%' || p_Uid || '%')
	AND (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%')
	AND (p_UNameEn = '' OR LOWER(U.Name_EN) ILIKE '%' || p_UNameEn || '%')

	ORDER BY COALESCE(S.SortNo, P.SortNo) ASC, U.Name ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
